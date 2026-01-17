<?php

namespace App\State\Processor;

use ApiPlatform\Metadata\Operation;
use ApiPlatform\Metadata\Post;
use ApiPlatform\State\ProcessorInterface;
use App\Entity\Task;
use App\Entity\User;
use App\Repository\MilestoneRepository;
use App\Repository\TaskRepository;
use App\Service\ActivityService;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\SecurityBundle\Security;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;

class TaskProcessor implements ProcessorInterface
{
    public function __construct(
        private readonly EntityManagerInterface $entityManager,
        private readonly Security $security,
        private readonly MilestoneRepository $milestoneRepository,
        private readonly TaskRepository $taskRepository,
        private readonly ActivityService $activityService,
    ) {
    }

    public function process(mixed $data, Operation $operation, array $uriVariables = [], array $context = []): Task
    {
        /** @var Task $task */
        $task = $data;

        /** @var User $user */
        $user = $this->security->getUser();

        $isNew = $operation instanceof Post;

        // Track status change for updates
        $oldStatus = null;
        if (!$isNew) {
            $unitOfWork = $this->entityManager->getUnitOfWork();
            $originalData = $unitOfWork->getOriginalEntityData($task);
            $oldStatus = $originalData['status'] ?? null;
        }

        if ($isNew) {
            $milestoneId = $uriVariables['milestoneId'] ?? null;

            if (!$milestoneId) {
                throw new NotFoundHttpException('Milestone not found');
            }

            $milestone = $this->milestoneRepository->find($milestoneId);

            if (!$milestone) {
                throw new NotFoundHttpException('Milestone not found');
            }

            $task->setMilestone($milestone);

            // Set position if not provided
            if ($task->getPosition() === 0) {
                $task->setPosition($this->taskRepository->getNextPosition($milestone, $task->getStatus()));
            }
        }

        $this->entityManager->persist($task);
        $this->entityManager->flush();

        // Log activity
        $project = $task->getMilestone()->getProject();

        if ($isNew) {
            $this->activityService->logTaskCreated(
                $project,
                $user,
                $task->getId(),
                $task->getTitle(),
            );
        } else {
            // Check if status changed
            if ($oldStatus !== null && $oldStatus !== $task->getStatus()) {
                $this->activityService->logTaskStatusChanged(
                    $project,
                    $user,
                    $task->getId(),
                    $task->getTitle(),
                    $oldStatus->value,
                    $task->getStatus()->value,
                );
            } else {
                $this->activityService->logTaskUpdated(
                    $project,
                    $user,
                    $task->getId(),
                    $task->getTitle(),
                );
            }
        }

        $this->entityManager->flush();

        return $task;
    }
}
