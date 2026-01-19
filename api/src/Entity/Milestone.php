<?php

namespace App\Entity;

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
use App\Enum\MilestoneStatus;
use App\Enum\TaskStatus;
use App\Repository\MilestoneRepository;
use App\State\Processor\MilestoneProcessor;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;
use Ramsey\Uuid\Uuid;
use Ramsey\Uuid\UuidInterface;
use Symfony\Component\Serializer\Attribute\Groups;
use Symfony\Component\Validator\Constraints as Assert;

#[ORM\Entity(repositoryClass: MilestoneRepository::class)]
#[ORM\HasLifecycleCallbacks]
#[ApiResource(
    uriTemplate: '/projects/{projectId}/milestones',
    operations: [
        new GetCollection(security: "is_granted('ROLE_USER')"),
        new Post(processor: MilestoneProcessor::class, security: "is_granted('ROLE_USER')", read: false),
    ],
    uriVariables: [
        'projectId' => new Link(toProperty: 'project', fromClass: Project::class, identifiers: ['id']),
    ],
    normalizationContext: ['groups' => ['milestone:read']],
    denormalizationContext: ['groups' => ['milestone:write']],
    order: ['dueDate' => 'ASC'],
)]
#[ApiResource(
    uriTemplate: '/projects/{projectId}/milestones/{id}',
    operations: [
        new Get(),
        new Patch(processor: MilestoneProcessor::class),
        new Delete(),
    ],
    uriVariables: [
        'projectId' => new Link(toProperty: 'project', fromClass: Project::class),
        'id' => new Link(fromClass: Milestone::class),
    ],
    normalizationContext: ['groups' => ['milestone:read']],
    denormalizationContext: ['groups' => ['milestone:write']],
    security: "is_granted('PROJECT_EDIT', object.getProject())",
)]
#[ApiFilter(SearchFilter::class, properties: ['name' => 'partial', 'status' => 'exact'])]
#[ApiFilter(OrderFilter::class, properties: ['name', 'dueDate', 'createdAt'])]
class Milestone
{
    #[ORM\Id]
    #[ORM\Column(type: 'uuid', unique: true)]
    #[Groups(['milestone:read', 'task:read'])]
    private UuidInterface $id;

    #[ORM\ManyToOne(targetEntity: Project::class, inversedBy: 'milestones')]
    #[ORM\JoinColumn(nullable: false, onDelete: 'CASCADE')]
    #[Groups(['milestone:read'])]
    private Project $project;

    #[ORM\Column(length: 255)]
    #[Assert\NotBlank]
    #[Assert\Length(min: 1, max: 255)]
    #[Groups(['milestone:read', 'milestone:write', 'task:read'])]
    private string $name;

    #[ORM\Column(type: Types::TEXT, nullable: true)]
    #[Groups(['milestone:read', 'milestone:write'])]
    private ?string $description = null;

    #[ORM\Column(type: Types::DATE_IMMUTABLE, nullable: true)]
    #[Groups(['milestone:read', 'milestone:write'])]
    private ?\DateTimeImmutable $dueDate = null;

    #[ORM\Column(type: 'string', enumType: MilestoneStatus::class)]
    #[Groups(['milestone:read', 'milestone:write'])]
    private MilestoneStatus $status = MilestoneStatus::OPEN;

    #[ORM\Column]
    #[Groups(['milestone:read'])]
    private \DateTimeImmutable $createdAt;

    #[ORM\Column]
    #[Groups(['milestone:read'])]
    private \DateTimeImmutable $updatedAt;

    /** @var Collection<int, Task> */
    #[ORM\OneToMany(targetEntity: Task::class, mappedBy: 'milestone', orphanRemoval: true)]
    private Collection $tasks;

    public function __construct()
    {
        $this->id = Uuid::uuid7();
        $this->tasks = new ArrayCollection();
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

    public function getProject(): Project
    {
        return $this->project;
    }

    public function setProject(Project $project): static
    {
        $this->project = $project;
        return $this;
    }

    public function getName(): string
    {
        return $this->name;
    }

    public function setName(string $name): static
    {
        $this->name = $name;
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

    public function getDueDate(): ?\DateTimeImmutable
    {
        return $this->dueDate;
    }

    public function setDueDate(?\DateTimeImmutable $dueDate): static
    {
        $this->dueDate = $dueDate;
        return $this;
    }

    public function getStatus(): MilestoneStatus
    {
        return $this->status;
    }

    public function setStatus(MilestoneStatus $status): static
    {
        $this->status = $status;
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
    public function getTasks(): Collection
    {
        return $this->tasks;
    }

    #[Groups(['milestone:read'])]
    public function getTaskCount(): int
    {
        return $this->tasks->count();
    }

    #[Groups(['milestone:read'])]
    public function getCompletedTaskCount(): int
    {
        return $this->tasks->filter(fn(Task $task) => $task->getStatus() === TaskStatus::COMPLETED)->count();
    }

    #[Groups(['milestone:read'])]
    public function getProgress(): int
    {
        $total = $this->tasks->count();
        if ($total === 0) {
            return 0;
        }
        return (int) round(($this->getCompletedTaskCount() / $total) * 100);
    }
}
