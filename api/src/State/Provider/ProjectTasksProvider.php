<?php

namespace App\State\Provider;

use ApiPlatform\Metadata\Operation;
use ApiPlatform\State\ProviderInterface;
use App\Repository\ProjectRepository;
use App\Repository\TaskRepository;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;

class ProjectTasksProvider implements ProviderInterface
{
    public function __construct(
        private readonly ProjectRepository $projectRepository,
        private readonly TaskRepository $taskRepository,
    ) {
    }

    public function provide(Operation $operation, array $uriVariables = [], array $context = []): array
    {
        $projectId = $uriVariables['projectId'] ?? null;

        if (!$projectId) {
            return [];
        }

        $project = $this->projectRepository->find($projectId);

        if (!$project) {
            throw new NotFoundHttpException('Project not found');
        }

        return $this->taskRepository->findByProject($project);
    }
}
