<?php

namespace App\Entity;

use ApiPlatform\Metadata\ApiResource;
use ApiPlatform\Metadata\Delete;
use ApiPlatform\Metadata\GetCollection;
use ApiPlatform\Metadata\Link;
use ApiPlatform\Metadata\Post;
use App\Repository\TaskAssigneeRepository;
use App\State\Processor\TaskAssigneeProcessor;
use Doctrine\ORM\Mapping as ORM;
use Ramsey\Uuid\Uuid;
use Ramsey\Uuid\UuidInterface;
use Symfony\Bridge\Doctrine\Validator\Constraints\UniqueEntity;
use Symfony\Component\Serializer\Attribute\Groups;
use Symfony\Component\Validator\Constraints as Assert;

#[ORM\Entity(repositoryClass: TaskAssigneeRepository::class)]
#[ORM\UniqueConstraint(name: 'task_user_unique', columns: ['task_id', 'user_id'])]
#[UniqueEntity(fields: ['task', 'user'], message: 'This user is already assigned to this task.')]
#[ApiResource(
    uriTemplate: '/tasks/{taskId}/assignees',
    operations: [
        new GetCollection(),
        new Post(processor: TaskAssigneeProcessor::class),
    ],
    uriVariables: [
        'taskId' => new Link(toProperty: 'task', fromClass: Task::class),
    ],
    normalizationContext: ['groups' => ['task_assignee:read']],
    denormalizationContext: ['groups' => ['task_assignee:write']],
    security: "is_granted('TASK_EDIT', object.getTask())",
)]
#[ApiResource(
    uriTemplate: '/tasks/{taskId}/assignees/{id}',
    operations: [new Delete()],
    uriVariables: [
        'taskId' => new Link(toProperty: 'task', fromClass: Task::class),
        'id' => new Link(fromClass: TaskAssignee::class),
    ],
    security: "is_granted('TASK_EDIT', object.getTask())",
)]
class TaskAssignee
{
    #[ORM\Id]
    #[ORM\Column(type: 'uuid', unique: true)]
    #[Groups(['task_assignee:read', 'task:read'])]
    private UuidInterface $id;

    #[ORM\ManyToOne(targetEntity: Task::class, inversedBy: 'assignees')]
    #[ORM\JoinColumn(nullable: false, onDelete: 'CASCADE')]
    private Task $task;

    #[ORM\ManyToOne(targetEntity: User::class, inversedBy: 'taskAssignments')]
    #[ORM\JoinColumn(nullable: false, onDelete: 'CASCADE')]
    #[Assert\NotNull]
    #[Groups(['task_assignee:read', 'task_assignee:write', 'task:read'])]
    private User $user;

    #[ORM\Column]
    #[Groups(['task_assignee:read', 'task:read'])]
    private \DateTimeImmutable $assignedAt;

    #[ORM\ManyToOne(targetEntity: User::class)]
    #[ORM\JoinColumn(nullable: true)]
    #[Groups(['task_assignee:read'])]
    private ?User $assignedBy = null;

    public function __construct()
    {
        $this->id = Uuid::uuid7();
        $this->assignedAt = new \DateTimeImmutable();
    }

    public function getId(): UuidInterface
    {
        return $this->id;
    }

    public function getTask(): Task
    {
        return $this->task;
    }

    public function setTask(Task $task): static
    {
        $this->task = $task;
        return $this;
    }

    public function getUser(): User
    {
        return $this->user;
    }

    public function setUser(User $user): static
    {
        $this->user = $user;
        return $this;
    }

    public function getAssignedAt(): \DateTimeImmutable
    {
        return $this->assignedAt;
    }

    public function getAssignedBy(): ?User
    {
        return $this->assignedBy;
    }

    public function setAssignedBy(?User $assignedBy): static
    {
        $this->assignedBy = $assignedBy;
        return $this;
    }
}
