<?php

namespace App\Repository;

use App\Entity\Project;
use App\Entity\User;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\ORM\QueryBuilder;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<Project>
 */
class ProjectRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Project::class);
    }

    public function createQueryBuilderForUser(User $user): QueryBuilder
    {
        return $this->createQueryBuilder('p')
            ->leftJoin('p.members', 'm')
            ->where('p.owner = :user')
            ->orWhere('m.user = :user')
            ->orWhere('p.isPublic = true')
            ->setParameter('user', $user)
            ->distinct()
            ->orderBy('p.createdAt', 'DESC');
    }

    /**
     * @return Project[]
     */
    public function findByUser(User $user): array
    {
        return $this->createQueryBuilderForUser($user)->getQuery()->getResult();
    }

    /**
     * Get recent projects for sidebar, filtering out hidden ones.
     *
     * @return Project[]
     */
    public function findRecentForUser(User $user, int $limit = 5): array
    {
        $projects = $this->findByUser($user);
        $hiddenIds = $user->getHiddenRecentProjectIds();

        $filtered = array_filter($projects, function (Project $project) use ($hiddenIds) {
            return !in_array((string) $project->getId(), $hiddenIds, true);
        });

        return array_slice(array_values($filtered), 0, $limit);
    }
}
