<?php

namespace App\State\Processor;

use ApiPlatform\Metadata\Operation;
use ApiPlatform\Metadata\Post;
use ApiPlatform\State\ProcessorInterface;
use App\Entity\Milestone;
use App\Entity\User;
use App\Repository\ProjectRepository;
use App\Service\ActivityService;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\SecurityBundle\Security;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;

class MilestoneProcessor implements ProcessorInterface
{
    public function __construct(
        private readonly EntityManagerInterface $entityManager,
        private readonly Security $security,
        private readonly ProjectRepository $projectRepository,
        private readonly ActivityService $activityService,
    ) {
    }

    public function process(mixed $data, Operation $operation, array $uriVariables = [], array $context = []): Milestone
    {
        /** @var Milestone $milestone */
        $milestone = $data;

        /** @var User $user */
        $user = $this->security->getUser();

        $isNew = $operation instanceof Post;

        if ($isNew) {
            $projectId = $uriVariables['projectId'] ?? null;

            if (!$projectId) {
                throw new NotFoundHttpException('Project not found');
            }

            $project = $this->projectRepository->find($projectId);

            if (!$project) {
                throw new NotFoundHttpException('Project not found');
            }

            $milestone->setProject($project);
        }

        $this->entityManager->persist($milestone);
        $this->entityManager->flush();

        // Log activity
        if ($isNew) {
            $this->activityService->logMilestoneCreated(
                $milestone->getProject(),
                $user,
                $milestone->getId(),
                $milestone->getName(),
            );
            $this->entityManager->flush();
        }

        return $milestone;
    }
}
