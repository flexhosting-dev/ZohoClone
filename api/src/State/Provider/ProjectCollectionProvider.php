<?php

namespace App\State\Provider;

use ApiPlatform\Metadata\Operation;
use ApiPlatform\State\ProviderInterface;
use App\Entity\User;
use App\Repository\ProjectRepository;
use Symfony\Bundle\SecurityBundle\Security;

class ProjectCollectionProvider implements ProviderInterface
{
    public function __construct(
        private readonly ProjectRepository $projectRepository,
        private readonly Security $security,
    ) {
    }

    public function provide(Operation $operation, array $uriVariables = [], array $context = []): array
    {
        /** @var User|null $user */
        $user = $this->security->getUser();

        if (!$user) {
            return [];
        }

        return $this->projectRepository->findByUser($user);
    }
}
