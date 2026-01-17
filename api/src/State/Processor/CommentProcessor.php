<?php

namespace App\State\Processor;

use ApiPlatform\Metadata\Operation;
use ApiPlatform\Metadata\Post;
use ApiPlatform\State\ProcessorInterface;
use App\Entity\Comment;
use App\Entity\User;
use App\Repository\TaskRepository;
use App\Service\ActivityService;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\SecurityBundle\Security;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;

class CommentProcessor implements ProcessorInterface
{
    public function __construct(
        private readonly EntityManagerInterface $entityManager,
        private readonly Security $security,
        private readonly TaskRepository $taskRepository,
        private readonly ActivityService $activityService,
    ) {
    }

    public function process(mixed $data, Operation $operation, array $uriVariables = [], array $context = []): Comment
    {
        /** @var Comment $comment */
        $comment = $data;

        /** @var User $user */
        $user = $this->security->getUser();

        $isNew = $operation instanceof Post;

        if ($isNew) {
            $taskId = $uriVariables['taskId'] ?? null;

            if (!$taskId) {
                throw new NotFoundHttpException('Task not found');
            }

            $task = $this->taskRepository->find($taskId);

            if (!$task) {
                throw new NotFoundHttpException('Task not found');
            }

            $comment->setTask($task);
            $comment->setAuthor($user);
        }

        $this->entityManager->persist($comment);
        $this->entityManager->flush();

        // Log activity for new comments
        if ($isNew) {
            $task = $comment->getTask();
            $project = $task->getMilestone()->getProject();

            $this->activityService->logCommentAdded(
                $project,
                $user,
                $task->getId(),
                $task->getTitle(),
            );
            $this->entityManager->flush();
        }

        return $comment;
    }
}
