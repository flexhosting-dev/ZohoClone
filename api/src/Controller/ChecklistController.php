<?php

namespace App\Controller;

use App\Entity\TaskChecklist;
use App\Repository\TaskRepository;
use App\Repository\TaskChecklistRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class ChecklistController extends AbstractController
{
    public function __construct(
        private readonly TaskRepository $taskRepository,
        private readonly TaskChecklistRepository $checklistRepository,
        private readonly EntityManagerInterface $entityManager,
    ) {
    }

    #[Route('/tasks/{taskId}/checklists', name: 'app_checklist_list', methods: ['GET'])]
    public function list(string $taskId): JsonResponse
    {
        $task = $this->taskRepository->find($taskId);
        if (!$task) {
            return $this->json(['error' => 'Task not found'], Response::HTTP_NOT_FOUND);
        }

        $project = $task->getProject();
        $this->denyAccessUnlessGranted('PROJECT_VIEW', $project);

        $items = $this->checklistRepository->findByTask($task);

        return $this->json([
            'items' => array_map(fn(TaskChecklist $item) => $this->serializeItem($item), $items),
            'totalCount' => count($items),
            'completedCount' => count(array_filter($items, fn(TaskChecklist $item) => $item->isCompleted())),
        ]);
    }

    #[Route('/tasks/{taskId}/checklists', name: 'app_checklist_create', methods: ['POST'])]
    public function create(Request $request, string $taskId): JsonResponse
    {
        $task = $this->taskRepository->find($taskId);
        if (!$task) {
            return $this->json(['error' => 'Task not found'], Response::HTTP_NOT_FOUND);
        }

        $project = $task->getProject();
        $this->denyAccessUnlessGranted('PROJECT_EDIT', $project);

        $data = json_decode($request->getContent(), true);
        $title = trim($data['title'] ?? '');

        if (empty($title)) {
            return $this->json(['error' => 'Title is required'], Response::HTTP_BAD_REQUEST);
        }

        if (strlen($title) > 500) {
            return $this->json(['error' => 'Title must be at most 500 characters'], Response::HTTP_BAD_REQUEST);
        }

        $maxPosition = $this->checklistRepository->findMaxPositionInTask($task);

        $item = new TaskChecklist();
        $item->setTask($task);
        $item->setTitle($title);
        $item->setPosition($maxPosition + 1);

        $this->entityManager->persist($item);
        $this->entityManager->flush();

        return $this->json([
            'success' => true,
            'item' => $this->serializeItem($item),
        ], Response::HTTP_CREATED);
    }

    #[Route('/tasks/{taskId}/checklists/{itemId}/toggle', name: 'app_checklist_toggle', methods: ['POST'])]
    public function toggle(string $taskId, string $itemId): JsonResponse
    {
        $task = $this->taskRepository->find($taskId);
        if (!$task) {
            return $this->json(['error' => 'Task not found'], Response::HTTP_NOT_FOUND);
        }

        $project = $task->getProject();
        $this->denyAccessUnlessGranted('PROJECT_EDIT', $project);

        $item = $this->checklistRepository->find($itemId);
        if (!$item || $item->getTask()->getId()->toString() !== $taskId) {
            return $this->json(['error' => 'Checklist item not found'], Response::HTTP_NOT_FOUND);
        }

        $item->toggle();
        $this->entityManager->flush();

        return $this->json([
            'success' => true,
            'item' => $this->serializeItem($item),
        ]);
    }

    #[Route('/tasks/{taskId}/checklists/{itemId}', name: 'app_checklist_update', methods: ['PATCH'])]
    public function update(Request $request, string $taskId, string $itemId): JsonResponse
    {
        $task = $this->taskRepository->find($taskId);
        if (!$task) {
            return $this->json(['error' => 'Task not found'], Response::HTTP_NOT_FOUND);
        }

        $project = $task->getProject();
        $this->denyAccessUnlessGranted('PROJECT_EDIT', $project);

        $item = $this->checklistRepository->find($itemId);
        if (!$item || $item->getTask()->getId()->toString() !== $taskId) {
            return $this->json(['error' => 'Checklist item not found'], Response::HTTP_NOT_FOUND);
        }

        $data = json_decode($request->getContent(), true);

        if (isset($data['title'])) {
            $title = trim($data['title']);
            if (empty($title)) {
                return $this->json(['error' => 'Title is required'], Response::HTTP_BAD_REQUEST);
            }
            if (strlen($title) > 500) {
                return $this->json(['error' => 'Title must be at most 500 characters'], Response::HTTP_BAD_REQUEST);
            }
            $item->setTitle($title);
        }

        $this->entityManager->flush();

        return $this->json([
            'success' => true,
            'item' => $this->serializeItem($item),
        ]);
    }

    #[Route('/tasks/{taskId}/checklists/{itemId}', name: 'app_checklist_delete', methods: ['DELETE'])]
    public function delete(string $taskId, string $itemId): JsonResponse
    {
        $task = $this->taskRepository->find($taskId);
        if (!$task) {
            return $this->json(['error' => 'Task not found'], Response::HTTP_NOT_FOUND);
        }

        $project = $task->getProject();
        $this->denyAccessUnlessGranted('PROJECT_EDIT', $project);

        $item = $this->checklistRepository->find($itemId);
        if (!$item || $item->getTask()->getId()->toString() !== $taskId) {
            return $this->json(['error' => 'Checklist item not found'], Response::HTTP_NOT_FOUND);
        }

        $this->entityManager->remove($item);
        $this->entityManager->flush();

        return $this->json(['success' => true]);
    }

    #[Route('/tasks/{taskId}/checklists/reorder', name: 'app_checklist_reorder', methods: ['POST'])]
    public function reorder(Request $request, string $taskId): JsonResponse
    {
        $task = $this->taskRepository->find($taskId);
        if (!$task) {
            return $this->json(['error' => 'Task not found'], Response::HTTP_NOT_FOUND);
        }

        $project = $task->getProject();
        $this->denyAccessUnlessGranted('PROJECT_EDIT', $project);

        $data = json_decode($request->getContent(), true);
        $itemIds = $data['itemIds'] ?? [];

        if (!is_array($itemIds)) {
            return $this->json(['error' => 'itemIds must be an array'], Response::HTTP_BAD_REQUEST);
        }

        $items = $this->checklistRepository->findByTask($task);
        $itemMap = [];
        foreach ($items as $item) {
            $itemMap[$item->getId()->toString()] = $item;
        }

        foreach ($itemIds as $position => $itemId) {
            if (isset($itemMap[$itemId])) {
                $itemMap[$itemId]->setPosition($position);
            }
        }

        $this->entityManager->flush();

        return $this->json(['success' => true]);
    }

    private function serializeItem(TaskChecklist $item): array
    {
        return [
            'id' => $item->getId()->toString(),
            'title' => $item->getTitle(),
            'isCompleted' => $item->isCompleted(),
            'position' => $item->getPosition(),
            'createdAt' => $item->getCreatedAt()->format('c'),
        ];
    }
}
