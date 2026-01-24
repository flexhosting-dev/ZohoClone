<?php

namespace App\Repository;

use App\Entity\TaskChecklist;
use App\Entity\Task;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<TaskChecklist>
 */
class TaskChecklistRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, TaskChecklist::class);
    }

    /**
     * @return TaskChecklist[]
     */
    public function findByTask(Task $task): array
    {
        return $this->findBy(['task' => $task], ['position' => 'ASC']);
    }

    public function findMaxPositionInTask(Task $task): int
    {
        $result = $this->createQueryBuilder('c')
            ->select('MAX(c.position)')
            ->where('c.task = :task')
            ->setParameter('task', $task)
            ->getQuery()
            ->getSingleScalarResult();

        return $result ?? -1;
    }
}
