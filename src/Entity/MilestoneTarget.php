<?php

namespace App\Entity;

use Doctrine\ORM\Mapping as ORM;
use Ramsey\Uuid\Uuid;
use Ramsey\Uuid\UuidInterface;

#[ORM\Entity]
#[ORM\HasLifecycleCallbacks]
class MilestoneTarget
{
    #[ORM\Id]
    #[ORM\Column(type: 'uuid', unique: true)]
    private UuidInterface $id;

    #[ORM\ManyToOne(targetEntity: Milestone::class, inversedBy: 'targets')]
    #[ORM\JoinColumn(nullable: false, onDelete: 'CASCADE')]
    private Milestone $milestone;

    #[ORM\Column(type: 'text')]
    private string $description;

    #[ORM\Column(type: 'integer')]
    private int $position = 0;

    #[ORM\Column(type: 'boolean')]
    private bool $completed = false;

    public function __construct()
    {
        $this->id = Uuid::uuid7();
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

    public function getDescription(): string
    {
        return $this->description;
    }

    public function setDescription(string $description): static
    {
        $this->description = $description;
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

    public function isCompleted(): bool
    {
        return $this->completed;
    }

    public function setCompleted(bool $completed): static
    {
        $this->completed = $completed;
        return $this;
    }
}
