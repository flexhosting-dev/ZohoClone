<?php

namespace App\State\Processor;

use ApiPlatform\Metadata\Operation;
use ApiPlatform\State\ProcessorInterface;
use App\Entity\TaskAssignee;
use App\Entity\User;
use App\Repository\TaskRepository;
use App\Service\ActivityService;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\SecurityBundle\Security;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;

class TaskAssigneeProcessor implements ProcessorInterface
{
    public function __construct(
        private readonly EntityManagerInterface $entityManager,
        private readonly Security $security,
        private readonly TaskRepository $taskRepository,
        private readonly ActivityService $activityService,
    ) {
    }

    public function process(mixed $data, Operation $operation, array $uriVariables = [], array $context = []): TaskAssignee
    {
        /** @var TaskAssignee $assignee */
        $assignee = $data;

        /** @var User $currentUser */
        $currentUser = $this->security->getUser();

        $taskId = $uriVariables['taskId'] ?? null;

        if (!$taskId) {
            throw new NotFoundHttpException('Task not found');
        }

        $task = $this->taskRepository->find($taskId);

        if (!$task) {
            throw new NotFoundHttpException('Task not found');
        }

        $assignee->setTask($task);
        $assignee->setAssignedBy($currentUser);

        $this->entityManager->persist($assignee);
        $this->entityManager->flush();

        // Log activity
        $project = $task->getMilestone()->getProject();
        $this->activityService->logTaskAssigned(
            $project,
            $currentUser,
            $task->getId(),
            $task->getTitle(),
            $assignee->getUser()->getFullName(),
        );
        $this->entityManager->flush();

        return $assignee;
    }
}
