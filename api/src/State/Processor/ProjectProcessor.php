<?php

namespace App\State\Processor;

use ApiPlatform\Metadata\Operation;
use ApiPlatform\Metadata\Post;
use ApiPlatform\State\ProcessorInterface;
use App\Entity\Project;
use App\Entity\ProjectMember;
use App\Entity\User;
use App\Enum\ProjectRole;
use App\Service\ActivityService;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\SecurityBundle\Security;

class ProjectProcessor implements ProcessorInterface
{
    public function __construct(
        private readonly EntityManagerInterface $entityManager,
        private readonly Security $security,
        private readonly ActivityService $activityService,
    ) {
    }

    public function process(mixed $data, Operation $operation, array $uriVariables = [], array $context = []): Project
    {
        /** @var Project $project */
        $project = $data;

        /** @var User $user */
        $user = $this->security->getUser();

        $isNew = $operation instanceof Post;

        if ($isNew) {
            // Set owner
            $project->setOwner($user);

            // Add owner as admin member
            $member = new ProjectMember();
            $member->setUser($user);
            $member->setRole(ProjectRole::ADMIN);
            $project->addMember($member);
        }

        $this->entityManager->persist($project);
        $this->entityManager->flush();

        // Log activity
        if ($isNew) {
            $this->activityService->logProjectCreated($project, $user);
            $this->entityManager->flush();
        } else {
            $this->activityService->logProjectUpdated($project, $user);
            $this->entityManager->flush();
        }

        return $project;
    }
}
