<?php

namespace App\Controller;

use App\Entity\User;
use App\Enum\TaskStatus;
use App\Repository\ActivityRepository;
use App\Repository\ProjectRepository;
use App\Repository\TaskRepository;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

#[Route('/api')]
class DashboardController extends AbstractController
{
    public function __construct(
        private readonly ProjectRepository $projectRepository,
        private readonly TaskRepository $taskRepository,
        private readonly ActivityRepository $activityRepository,
    ) {
    }

    #[Route('/dashboard', name: 'api_dashboard', methods: ['GET'])]
    public function dashboard(): JsonResponse
    {
        /** @var User|null $user */
        $user = $this->getUser();

        if (!$user) {
            return $this->json(['error' => 'Not authenticated'], Response::HTTP_UNAUTHORIZED);
        }

        // Get user's projects
        $projects = $this->projectRepository->findByUser($user);
        $projectIds = array_map(fn($p) => $p->getId(), $projects);

        // Get task counts
        $userTasks = $this->taskRepository->findUserTasks($user);
        $overdueTasks = $this->taskRepository->findOverdueTasks($user);
        $tasksDueToday = $this->taskRepository->findTasksDueToday($user);

        // Count by status
        $tasksByStatus = [
            'todo' => 0,
            'in_progress' => 0,
            'in_review' => 0,
            'completed' => 0,
        ];

        foreach ($userTasks as $task) {
            $status = $task->getStatus()->value;
            $tasksByStatus[$status]++;
        }

        // Get recent activities
        $recentActivities = $this->activityRepository->findRecentForProjects($projectIds, 10);

        $activitiesData = array_map(fn($activity) => [
            'id' => $activity->getId()->toString(),
            'description' => $activity->getDescription(),
            'entityType' => $activity->getEntityType(),
            'action' => $activity->getAction()->value,
            'createdAt' => $activity->getCreatedAt()->format('c'),
            'user' => [
                'id' => $activity->getUser()->getId()->toString(),
                'fullName' => $activity->getUser()->getFullName(),
            ],
        ], $recentActivities);

        // Get upcoming tasks (next 7 days)
        $upcomingTasks = array_filter($userTasks, function($task) {
            if ($task->getStatus() === TaskStatus::COMPLETED) {
                return false;
            }
            $dueDate = $task->getDueDate();
            if (!$dueDate) {
                return false;
            }
            $now = new \DateTimeImmutable('today');
            $nextWeek = $now->modify('+7 days');
            return $dueDate >= $now && $dueDate <= $nextWeek;
        });

        $upcomingTasksData = array_values(array_map(fn($task) => [
            'id' => $task->getId()->toString(),
            'title' => $task->getTitle(),
            'status' => $task->getStatus()->value,
            'priority' => $task->getPriority()->value,
            'dueDate' => $task->getDueDate()?->format('Y-m-d'),
            'project' => [
                'id' => $task->getProject()->getId()->toString(),
                'name' => $task->getProject()->getName(),
            ],
        ], array_slice($upcomingTasks, 0, 5)));

        return $this->json([
            'stats' => [
                'totalProjects' => count($projects),
                'totalTasks' => count($userTasks),
                'overdueTasks' => count($overdueTasks),
                'tasksDueToday' => count($tasksDueToday),
                'completedTasks' => $tasksByStatus['completed'],
            ],
            'tasksByStatus' => $tasksByStatus,
            'recentActivities' => $activitiesData,
            'upcomingTasks' => $upcomingTasksData,
        ]);
    }
}
