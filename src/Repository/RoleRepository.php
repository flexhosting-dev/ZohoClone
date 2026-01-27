<?php

namespace App\Repository;

use App\Entity\Role;
use App\Enum\RoleType;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<Role>
 */
class RoleRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Role::class);
    }

    public function findBySlug(string $slug): ?Role
    {
        return $this->findOneBy(['slug' => $slug]);
    }

    public function findPortalRoles(): array
    {
        return $this->findBy(['type' => RoleType::PORTAL], ['name' => 'ASC']);
    }

    public function findProjectRoles(): array
    {
        return $this->findBy(['type' => RoleType::PROJECT], ['name' => 'ASC']);
    }

    public function findSystemRoles(): array
    {
        return $this->findBy(['isSystemRole' => true], ['type' => 'ASC', 'name' => 'ASC']);
    }

    public function findCustomRoles(): array
    {
        return $this->findBy(['isSystemRole' => false], ['type' => 'ASC', 'name' => 'ASC']);
    }
}
