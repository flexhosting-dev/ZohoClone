<?php

namespace App\Entity;

use ApiPlatform\Metadata\ApiResource;
use ApiPlatform\Metadata\Delete;
use ApiPlatform\Metadata\Get;
use ApiPlatform\Metadata\GetCollection;
use ApiPlatform\Metadata\Link;
use ApiPlatform\Metadata\Patch;
use ApiPlatform\Metadata\Post;
use App\Enum\ProjectRole;
use App\Repository\ProjectMemberRepository;
use App\State\Processor\ProjectMemberProcessor;
use Doctrine\ORM\Mapping as ORM;
use Ramsey\Uuid\Uuid;
use Ramsey\Uuid\UuidInterface;
use Symfony\Bridge\Doctrine\Validator\Constraints\UniqueEntity;
use Symfony\Component\Serializer\Attribute\Groups;
use Symfony\Component\Validator\Constraints as Assert;

#[ORM\Entity(repositoryClass: ProjectMemberRepository::class)]
#[ORM\UniqueConstraint(name: 'project_user_unique', columns: ['project_id', 'user_id'])]
#[UniqueEntity(fields: ['project', 'user'], message: 'This user is already a member of this project.')]
#[ApiResource(
    uriTemplate: '/projects/{projectId}/members',
    operations: [new GetCollection(), new Post(processor: ProjectMemberProcessor::class)],
    uriVariables: [
        'projectId' => new Link(toProperty: 'project', fromClass: Project::class),
    ],
    normalizationContext: ['groups' => ['project_member:read']],
    denormalizationContext: ['groups' => ['project_member:write']],
    security: "is_granted('PROJECT_VIEW', object.getProject())",
)]
#[ApiResource(
    uriTemplate: '/projects/{projectId}/members/{id}',
    operations: [
        new Get(),
        new Patch(processor: ProjectMemberProcessor::class),
        new Delete(),
    ],
    uriVariables: [
        'projectId' => new Link(toProperty: 'project', fromClass: Project::class),
        'id' => new Link(fromClass: ProjectMember::class),
    ],
    normalizationContext: ['groups' => ['project_member:read']],
    denormalizationContext: ['groups' => ['project_member:write']],
    security: "is_granted('PROJECT_MANAGE_MEMBERS', object.getProject())",
)]
class ProjectMember
{
    #[ORM\Id]
    #[ORM\Column(type: 'uuid', unique: true)]
    #[Groups(['project_member:read', 'project:read'])]
    private UuidInterface $id;

    #[ORM\ManyToOne(targetEntity: Project::class, inversedBy: 'members')]
    #[ORM\JoinColumn(nullable: false, onDelete: 'CASCADE')]
    private Project $project;

    #[ORM\ManyToOne(targetEntity: User::class, inversedBy: 'projectMemberships')]
    #[ORM\JoinColumn(nullable: false, onDelete: 'CASCADE')]
    #[Assert\NotNull]
    #[Groups(['project_member:read', 'project_member:write', 'project:read'])]
    private User $user;

    #[ORM\Column(type: 'string', enumType: ProjectRole::class)]
    #[Groups(['project_member:read', 'project_member:write', 'project:read'])]
    private ProjectRole $role = ProjectRole::MEMBER;

    #[ORM\Column]
    #[Groups(['project_member:read', 'project:read'])]
    private \DateTimeImmutable $joinedAt;

    public function __construct()
    {
        $this->id = Uuid::uuid7();
        $this->joinedAt = new \DateTimeImmutable();
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

    public function getUser(): User
    {
        return $this->user;
    }

    public function setUser(User $user): static
    {
        $this->user = $user;
        return $this;
    }

    public function getRole(): ProjectRole
    {
        return $this->role;
    }

    public function setRole(ProjectRole $role): static
    {
        $this->role = $role;
        return $this;
    }

    public function getJoinedAt(): \DateTimeImmutable
    {
        return $this->joinedAt;
    }
}
