<?php

namespace App\Repository;

use App\Entity\Project;
use App\Entity\ProjectMember;
use App\Entity\User;
use App\Enum\ProjectRole;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<ProjectMember>
 */
class ProjectMemberRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, ProjectMember::class);
    }

    public function findByProjectAndUser(Project $project, User $user): ?ProjectMember
    {
        return $this->findOneBy(['project' => $project, 'user' => $user]);
    }

    public function getUserRoleInProject(Project $project, User $user): ?ProjectRole
    {
        $member = $this->findByProjectAndUser($project, $user);
        return $member?->getRole();
    }

    public function isUserMemberOfProject(Project $project, User $user): bool
    {
        return $this->findByProjectAndUser($project, $user) !== null;
    }
}
