<?php

namespace App\Entity;

use ApiPlatform\Doctrine\Orm\Filter\OrderFilter;
use ApiPlatform\Metadata\ApiFilter;
use ApiPlatform\Metadata\ApiResource;
use ApiPlatform\Metadata\Delete;
use ApiPlatform\Metadata\Get;
use ApiPlatform\Metadata\GetCollection;
use ApiPlatform\Metadata\Link;
use ApiPlatform\Metadata\Patch;
use ApiPlatform\Metadata\Post;
use App\Repository\CommentRepository;
use App\State\Processor\CommentProcessor;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;
use Ramsey\Uuid\Uuid;
use Ramsey\Uuid\UuidInterface;
use Symfony\Component\Serializer\Attribute\Groups;
use Symfony\Component\Validator\Constraints as Assert;

#[ORM\Entity(repositoryClass: CommentRepository::class)]
#[ORM\HasLifecycleCallbacks]
#[ApiResource(
    uriTemplate: '/tasks/{taskId}/comments',
    operations: [
        new GetCollection(),
        new Post(processor: CommentProcessor::class),
    ],
    uriVariables: [
        'taskId' => new Link(toProperty: 'task', fromClass: Task::class),
    ],
    normalizationContext: ['groups' => ['comment:read']],
    denormalizationContext: ['groups' => ['comment:write']],
    security: "is_granted('TASK_VIEW', object.getTask())",
    order: ['createdAt' => 'DESC'],
)]
#[ApiResource(
    uriTemplate: '/tasks/{taskId}/comments/{id}',
    operations: [
        new Get(),
        new Patch(processor: CommentProcessor::class),
        new Delete(),
    ],
    uriVariables: [
        'taskId' => new Link(toProperty: 'task', fromClass: Task::class),
        'id' => new Link(fromClass: Comment::class),
    ],
    normalizationContext: ['groups' => ['comment:read']],
    denormalizationContext: ['groups' => ['comment:write']],
    security: "is_granted('COMMENT_EDIT', object)",
)]
#[ApiFilter(OrderFilter::class, properties: ['createdAt'])]
class Comment
{
    #[ORM\Id]
    #[ORM\Column(type: 'uuid', unique: true)]
    #[Groups(['comment:read'])]
    private UuidInterface $id;

    #[ORM\ManyToOne(targetEntity: Task::class, inversedBy: 'comments')]
    #[ORM\JoinColumn(nullable: false, onDelete: 'CASCADE')]
    #[Groups(['comment:read'])]
    private Task $task;

    #[ORM\ManyToOne(targetEntity: User::class, inversedBy: 'comments')]
    #[ORM\JoinColumn(nullable: false)]
    #[Groups(['comment:read'])]
    private User $author;

    #[ORM\Column(type: Types::TEXT)]
    #[Assert\NotBlank]
    #[Assert\Length(min: 1, max: 10000)]
    #[Groups(['comment:read', 'comment:write'])]
    private string $content;

    #[ORM\Column]
    #[Groups(['comment:read'])]
    private \DateTimeImmutable $createdAt;

    #[ORM\Column]
    #[Groups(['comment:read'])]
    private \DateTimeImmutable $updatedAt;

    public function __construct()
    {
        $this->id = Uuid::uuid7();
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

    public function getTask(): Task
    {
        return $this->task;
    }

    public function setTask(Task $task): static
    {
        $this->task = $task;
        return $this;
    }

    public function getAuthor(): User
    {
        return $this->author;
    }

    public function setAuthor(User $author): static
    {
        $this->author = $author;
        return $this;
    }

    public function getContent(): string
    {
        return $this->content;
    }

    public function setContent(string $content): static
    {
        $this->content = $content;
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

    #[Groups(['comment:read'])]
    public function isEdited(): bool
    {
        return $this->updatedAt > $this->createdAt;
    }
}
