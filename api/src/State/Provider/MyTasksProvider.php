<?php

namespace App\State\Provider;

use ApiPlatform\Metadata\Operation;
use ApiPlatform\State\ProviderInterface;
use App\Entity\User;
use App\Repository\TaskRepository;
use Symfony\Bundle\SecurityBundle\Security;

class MyTasksProvider implements ProviderInterface
{
    public function __construct(
        private readonly TaskRepository $taskRepository,
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

        return $this->taskRepository->findUserTasks($user);
    }
}
