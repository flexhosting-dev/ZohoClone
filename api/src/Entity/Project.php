<?php

namespace App\Entity;

use ApiPlatform\Doctrine\Orm\Filter\OrderFilter;
use ApiPlatform\Doctrine\Orm\Filter\SearchFilter;
use ApiPlatform\Metadata\ApiFilter;
use ApiPlatform\Metadata\ApiResource;
use ApiPlatform\Metadata\Delete;
use ApiPlatform\Metadata\Get;
use ApiPlatform\Metadata\GetCollection;
use ApiPlatform\Metadata\Patch;
use ApiPlatform\Metadata\Post;
use App\Enum\ProjectStatus;
use App\Repository\ProjectRepository;
use App\State\Processor\ProjectProcessor;
use App\State\Provider\ProjectCollectionProvider;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;
use Ramsey\Uuid\Uuid;
use Ramsey\Uuid\UuidInterface;
use Symfony\Component\Serializer\Attribute\Groups;
use Symfony\Component\Validator\Constraints as Assert;

#[ORM\Entity(repositoryClass: ProjectRepository::class)]
#[ORM\HasLifecycleCallbacks]
#[ApiResource(
    operations: [
        new GetCollection(provider: ProjectCollectionProvider::class),
        new Post(processor: ProjectProcessor::class, security: "is_granted('ROLE_USER')"),
        new Get(security: "is_granted('PROJECT_VIEW', object)"),
        new Patch(security: "is_granted('PROJECT_EDIT', object)", processor: ProjectProcessor::class),
        new Delete(security: "is_granted('PROJECT_DELETE', object)"),
    ],
    normalizationContext: ['groups' => ['project:read']],
    denormalizationContext: ['groups' => ['project:write']],
    order: ['createdAt' => 'DESC'],
)]
#[ApiFilter(SearchFilter::class, properties: ['name' => 'partial', 'status' => 'exact'])]
#[ApiFilter(OrderFilter::class, properties: ['name', 'createdAt', 'startDate', 'endDate'])]
class Project
{
    #[ORM\Id]
    #[ORM\Column(type: 'uuid', unique: true)]
    #[Groups(['project:read', 'task:read', 'milestone:read'])]
    private UuidInterface $id;

    #[ORM\Column(length: 255)]
    #[Assert\NotBlank]
    #[Assert\Length(min: 1, max: 255)]
    #[Groups(['project:read', 'project:write', 'task:read', 'milestone:read'])]
    private string $name;

    #[ORM\Column(type: Types::TEXT, nullable: true)]
    #[Groups(['project:read', 'project:write'])]
    private ?string $description = null;

    #[ORM\Column(type: 'string', enumType: ProjectStatus::class)]
    #[Groups(['project:read', 'project:write'])]
    private ProjectStatus $status = ProjectStatus::ACTIVE;

    #[ORM\Column(type: Types::DATE_IMMUTABLE, nullable: true)]
    #[Groups(['project:read', 'project:write'])]
    private ?\DateTimeImmutable $startDate = null;

    #[ORM\Column(type: Types::DATE_IMMUTABLE, nullable: true)]
    #[Groups(['project:read', 'project:write'])]
    private ?\DateTimeImmutable $endDate = null;

    #[ORM\ManyToOne(targetEntity: User::class, inversedBy: 'ownedProjects')]
    #[ORM\JoinColumn(nullable: false)]
    #[Groups(['project:read'])]
    private User $owner;

    #[ORM\Column]
    #[Groups(['project:read'])]
    private \DateTimeImmutable $createdAt;

    #[ORM\Column]
    #[Groups(['project:read'])]
    private \DateTimeImmutable $updatedAt;

    /** @var Collection<int, ProjectMember> */
    #[ORM\OneToMany(targetEntity: ProjectMember::class, mappedBy: 'project', orphanRemoval: true, cascade: ['persist'])]
    #[Groups(['project:read'])]
    private Collection $members;

    /** @var Collection<int, Milestone> */
    #[ORM\OneToMany(targetEntity: Milestone::class, mappedBy: 'project', orphanRemoval: true)]
    private Collection $milestones;

    /** @var Collection<int, Activity> */
    #[ORM\OneToMany(targetEntity: Activity::class, mappedBy: 'project', orphanRemoval: true)]
    private Collection $activities;

    public function __construct()
    {
        $this->id = Uuid::uuid7();
        $this->members = new ArrayCollection();
        $this->milestones = new ArrayCollection();
        $this->activities = new ArrayCollection();
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

    public function getStatus(): ProjectStatus
    {
        return $this->status;
    }

    public function setStatus(ProjectStatus $status): static
    {
        $this->status = $status;
        return $this;
    }

    public function getStartDate(): ?\DateTimeImmutable
    {
        return $this->startDate;
    }

    public function setStartDate(?\DateTimeImmutable $startDate): static
    {
        $this->startDate = $startDate;
        return $this;
    }

    public function getEndDate(): ?\DateTimeImmutable
    {
        return $this->endDate;
    }

    public function setEndDate(?\DateTimeImmutable $endDate): static
    {
        $this->endDate = $endDate;
        return $this;
    }

    public function getOwner(): User
    {
        return $this->owner;
    }

    public function setOwner(User $owner): static
    {
        $this->owner = $owner;
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

    /** @return Collection<int, ProjectMember> */
    public function getMembers(): Collection
    {
        return $this->members;
    }

    public function addMember(ProjectMember $member): static
    {
        if (!$this->members->contains($member)) {
            $this->members->add($member);
            $member->setProject($this);
        }
        return $this;
    }

    public function removeMember(ProjectMember $member): static
    {
        if ($this->members->removeElement($member)) {
            if ($member->getProject() === $this) {
                $member->setProject($this);
            }
        }
        return $this;
    }

    /** @return Collection<int, Milestone> */
    public function getMilestones(): Collection
    {
        return $this->milestones;
    }

    /** @return Collection<int, Activity> */
    public function getActivities(): Collection
    {
        return $this->activities;
    }

    #[Groups(['project:read'])]
    public function getMemberCount(): int
    {
        return $this->members->count();
    }

    #[Groups(['project:read'])]
    public function getMilestoneCount(): int
    {
        return $this->milestones->count();
    }
}
