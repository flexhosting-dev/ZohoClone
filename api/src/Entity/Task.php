<?php

namespace App\Entity;

use ApiPlatform\Doctrine\Orm\Filter\BooleanFilter;
use ApiPlatform\Doctrine\Orm\Filter\DateFilter;
use ApiPlatform\Doctrine\Orm\Filter\OrderFilter;
use ApiPlatform\Doctrine\Orm\Filter\SearchFilter;
use ApiPlatform\Metadata\ApiFilter;
use ApiPlatform\Metadata\ApiResource;
use ApiPlatform\Metadata\Delete;
use ApiPlatform\Metadata\Get;
use ApiPlatform\Metadata\GetCollection;
use ApiPlatform\Metadata\Link;
use ApiPlatform\Metadata\Patch;
use ApiPlatform\Metadata\Post;
use App\Enum\TaskPriority;
use App\Enum\TaskStatus;
use App\Repository\TaskRepository;
use App\State\Processor\TaskProcessor;
use App\State\Provider\MyTasksProvider;
use App\State\Provider\ProjectTasksProvider;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;
use Ramsey\Uuid\Uuid;
use Ramsey\Uuid\UuidInterface;
use Symfony\Component\Serializer\Attribute\Groups;
use Symfony\Component\Validator\Constraints as Assert;

#[ORM\Entity(repositoryClass: TaskRepository::class)]
#[ORM\HasLifecycleCallbacks]
#[ORM\Index(name: 'idx_task_status', columns: ['status'])]
#[ORM\Index(name: 'idx_task_priority', columns: ['priority'])]
#[ORM\Index(name: 'idx_task_due_date', columns: ['due_date'])]
#[ApiResource(
    uriTemplate: '/milestones/{milestoneId}/tasks',
    operations: [
        new GetCollection(security: "is_granted('ROLE_USER')"),
        new Post(processor: TaskProcessor::class, security: "is_granted('ROLE_USER')", read: false),
    ],
    uriVariables: [
        'milestoneId' => new Link(toProperty: 'milestone', fromClass: Milestone::class, identifiers: ['id']),
    ],
    normalizationContext: ['groups' => ['task:read']],
    denormalizationContext: ['groups' => ['task:write']],
    order: ['position' => 'ASC'],
)]
#[ApiResource(
    uriTemplate: '/milestones/{milestoneId}/tasks/{id}',
    operations: [
        new Get(),
        new Patch(processor: TaskProcessor::class),
        new Delete(),
    ],
    uriVariables: [
        'milestoneId' => new Link(toProperty: 'milestone', fromClass: Milestone::class),
        'id' => new Link(fromClass: Task::class),
    ],
    normalizationContext: ['groups' => ['task:read']],
    denormalizationContext: ['groups' => ['task:write']],
    security: "is_granted('TASK_EDIT', object)",
)]
#[ApiResource(
    uriTemplate: '/projects/{projectId}/tasks',
    operations: [new GetCollection(provider: ProjectTasksProvider::class)],
    uriVariables: [
        'projectId' => new Link(fromClass: Project::class),
    ],
    normalizationContext: ['groups' => ['task:read']],
    security: "is_granted('ROLE_USER')",
    order: ['position' => 'ASC'],
)]
#[ApiResource(
    uriTemplate: '/my-tasks',
    operations: [new GetCollection(provider: MyTasksProvider::class)],
    normalizationContext: ['groups' => ['task:read']],
    security: "is_granted('ROLE_USER')",
)]
#[ApiFilter(SearchFilter::class, properties: ['title' => 'partial', 'status' => 'exact', 'priority' => 'exact'])]
#[ApiFilter(DateFilter::class, properties: ['dueDate'])]
#[ApiFilter(OrderFilter::class, properties: ['title', 'dueDate', 'priority', 'status', 'position', 'createdAt'])]
class Task
{
    #[ORM\Id]
    #[ORM\Column(type: 'uuid', unique: true)]
    #[Groups(['task:read', 'comment:read'])]
    private UuidInterface $id;

    #[ORM\ManyToOne(targetEntity: Milestone::class, inversedBy: 'tasks')]
    #[ORM\JoinColumn(nullable: false, onDelete: 'CASCADE')]
    #[Groups(['task:read'])]
    private Milestone $milestone;

    #[ORM\ManyToOne(targetEntity: Task::class, inversedBy: 'subtasks')]
    #[ORM\JoinColumn(onDelete: 'CASCADE')]
    #[Groups(['task:read', 'task:write'])]
    private ?Task $parent = null;

    #[ORM\Column(length: 255)]
    #[Assert\NotBlank]
    #[Assert\Length(min: 1, max: 255)]
    #[Groups(['task:read', 'task:write', 'comment:read'])]
    private string $title;

    #[ORM\Column(type: Types::TEXT, nullable: true)]
    #[Groups(['task:read', 'task:write'])]
    private ?string $description = null;

    #[ORM\Column(type: 'string', enumType: TaskStatus::class)]
    #[Groups(['task:read', 'task:write'])]
    private TaskStatus $status = TaskStatus::TODO;

    #[ORM\Column(type: 'string', enumType: TaskPriority::class)]
    #[Groups(['task:read', 'task:write'])]
    private TaskPriority $priority = TaskPriority::MEDIUM;

    #[ORM\Column(type: Types::DATE_IMMUTABLE, nullable: true)]
    #[Groups(['task:read', 'task:write'])]
    private ?\DateTimeImmutable $dueDate = null;

    #[ORM\Column]
    #[Groups(['task:read', 'task:write'])]
    private int $position = 0;

    #[ORM\Column]
    #[Groups(['task:read'])]
    private \DateTimeImmutable $createdAt;

    #[ORM\Column]
    #[Groups(['task:read'])]
    private \DateTimeImmutable $updatedAt;

    /** @var Collection<int, Task> */
    #[ORM\OneToMany(targetEntity: Task::class, mappedBy: 'parent', orphanRemoval: true)]
    #[Groups(['task:read'])]
    private Collection $subtasks;

    /** @var Collection<int, TaskAssignee> */
    #[ORM\OneToMany(targetEntity: TaskAssignee::class, mappedBy: 'task', orphanRemoval: true, cascade: ['persist', 'remove'])]
    #[Groups(['task:read'])]
    private Collection $assignees;

    /** @var Collection<int, Comment> */
    #[ORM\OneToMany(targetEntity: Comment::class, mappedBy: 'task', orphanRemoval: true)]
    private Collection $comments;

    public function __construct()
    {
        $this->id = Uuid::uuid7();
        $this->subtasks = new ArrayCollection();
        $this->assignees = new ArrayCollection();
        $this->comments = new ArrayCollection();
    }

    #[ORM\PrePersist]
    public function setCreatedAtValue(): void
    {
        $this->createdAt = new \DateTimeImmutable();
        $this->updatedAt = new \DateTimeImmutable();
    }

    #[ORM\PreUpdate]
    public function setUpdatedAtValue(): void
    {
        $this->updatedAt = new \DateTimeImmutable();
    }

    public function getId(): UuidInterface
    {
        return $this->id;
    }

    public function getMilestone(): Milestone
    {
        return $this->milestone;
    }

    public function setMilestone(Milestone $milestone): static
    {
        $this->milestone = $milestone;
        return $this;
    }

    public function getParent(): ?Task
    {
        return $this->parent;
    }

    public function setParent(?Task $parent): static
    {
        $this->parent = $parent;
        return $this;
    }

    public function getTitle(): string
    {
        return $this->title;
    }

    public function setTitle(string $title): static
    {
        $this->title = $title;
        return $this;
    }

    public function getDescription(): ?string
    {
        return $this->description;
    }

    public function setDescription(?string $description): static
    {
        $this->description = $description;
        return $this;
    }

    public function getStatus(): TaskStatus
    {
        return $this->status;
    }

    public function setStatus(TaskStatus $status): static
    {
        $this->status = $status;
        return $this;
    }

    public function getPriority(): TaskPriority
    {
        return $this->priority;
    }

    public function setPriority(TaskPriority $priority): static
    {
        $this->priority = $priority;
        return $this;
    }

    public function getDueDate(): ?\DateTimeImmutable
    {
        return $this->dueDate;
    }

    public function setDueDate(?\DateTimeImmutable $dueDate): static
    {
        $this->dueDate = $dueDate;
        return $this;
    }

    public function getPosition(): int
    {
        return $this->position;
    }

    public function setPosition(int $position): static
    {
        $this->position = $position;
        return $this;
    }

    public function getCreatedAt(): \DateTimeImmutable
    {
        return $this->createdAt;
    }

    public function getUpdatedAt(): \DateTimeImmutable
    {
        return $this->updatedAt;
    }

    /** @return Collection<int, Task> */
    public function getSubtasks(): Collection
    {
        return $this->subtasks;
    }

    public function addSubtask(Task $subtask): static
    {
        if (!$this->subtasks->contains($subtask)) {
            $this->subtasks->add($subtask);
            $subtask->setParent($this);
        }
        return $this;
    }

    public function removeSubtask(Task $subtask): static
    {
        if ($this->subtasks->removeElement($subtask)) {
            if ($subtask->getParent() === $this) {
                $subtask->setParent(null);
            }
        }
        return $this;
    }

    /** @return Collection<int, TaskAssignee> */
    public function getAssignees(): Collection
    {
        return $this->assignees;
    }

    public function addAssignee(TaskAssignee $assignee): static
    {
        if (!$this->assignees->contains($assignee)) {
            $this->assignees->add($assignee);
            $assignee->setTask($this);
        }
        return $this;
    }

    public function removeAssignee(TaskAssignee $assignee): static
    {
        if ($this->assignees->removeElement($assignee)) {
            if ($assignee->getTask() === $this) {
                $assignee->setTask($this);
            }
        }
        return $this;
    }

    /** @return Collection<int, Comment> */
    public function getComments(): Collection
    {
        return $this->comments;
    }

    #[Groups(['task:read'])]
    public function getSubtaskCount(): int
    {
        return $this->subtasks->count();
    }

    #[Groups(['task:read'])]
    public function getCommentCount(): int
    {
        return $this->comments->count();
    }

    #[Groups(['task:read'])]
    public function getProject(): Project
    {
        return $this->milestone->getProject();
    }

    #[Groups(['task:read'])]
    public function isOverdue(): bool
    {
        if ($this->dueDate === null) {
            return false;
        }
        if ($this->status === TaskStatus::COMPLETED) {
            return false;
        }
        return $this->dueDate < new \DateTimeImmutable('today');
    }
}
