<?php

namespace App\Entity;

use App\Enum\RoleType;
use App\Repository\RoleRepository;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Bridge\Doctrine\Types\UuidType;
use Symfony\Component\Uid\Uuid;

#[ORM\Entity(repositoryClass: RoleRepository::class)]
#[ORM\Table(name: 'role')]
#[ORM\UniqueConstraint(name: 'UNIQ_ROLE_SLUG', columns: ['slug'])]
class Role
{
    #[ORM\Id]
    #[ORM\Column(type: UuidType::NAME, unique: true)]
    private Uuid $id;

    #[ORM\Column(length: 100)]
    private string $name;

    #[ORM\Column(length: 100, unique: true)]
    private string $slug;

    #[ORM\Column(type: 'text', nullable: true)]
    private ?string $description = null;

    #[ORM\Column(enumType: RoleType::class)]
    private RoleType $type;

    #[ORM\Column]
    private bool $isSystemRole = false;

    #[ORM\Column(type: 'json')]
    private array $permissions = [];

    #[ORM\Column]
    private \DateTimeImmutable $createdAt;

    #[ORM\Column]
    private \DateTimeImmutable $updatedAt;

    public function __construct()
    {
        $this->id = Uuid::v7();
        $this->createdAt = new \DateTimeImmutable();
        $this->updatedAt = new \DateTimeImmutable();
    }

    public function getId(): Uuid
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

    public function getSlug(): string
    {
        return $this->slug;
    }

    public function setSlug(string $slug): static
    {
        $this->slug = $slug;
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

    public function getType(): RoleType
    {
        return $this->type;
    }

    public function setType(RoleType $type): static
    {
        $this->type = $type;
        return $this;
    }

    public function isSystemRole(): bool
    {
        return $this->isSystemRole;
    }

    public function setIsSystemRole(bool $isSystemRole): static
    {
        $this->isSystemRole = $isSystemRole;
        return $this;
    }

    public function getPermissions(): array
    {
        return $this->permissions;
    }

    public function setPermissions(array $permissions): static
    {
        $this->permissions = $permissions;
        $this->updatedAt = new \DateTimeImmutable();
        return $this;
    }

    public function addPermission(string $permission): static
    {
        if (!in_array($permission, $this->permissions, true)) {
            $this->permissions[] = $permission;
            $this->updatedAt = new \DateTimeImmutable();
        }
        return $this;
    }

    public function removePermission(string $permission): static
    {
        $key = array_search($permission, $this->permissions, true);
        if ($key !== false) {
            unset($this->permissions[$key]);
            $this->permissions = array_values($this->permissions);
            $this->updatedAt = new \DateTimeImmutable();
        }
        return $this;
    }

    public function hasPermission(string $permission): bool
    {
        return in_array($permission, $this->permissions, true);
    }

    public function getCreatedAt(): \DateTimeImmutable
    {
        return $this->createdAt;
    }

    public function getUpdatedAt(): \DateTimeImmutable
    {
        return $this->updatedAt;
    }

    public function setUpdatedAt(\DateTimeImmutable $updatedAt): static
    {
        $this->updatedAt = $updatedAt;
        return $this;
    }

    public function isPortalRole(): bool
    {
        return $this->type === RoleType::PORTAL;
    }

    public function isProjectRole(): bool
    {
        return $this->type === RoleType::PROJECT;
    }
}
