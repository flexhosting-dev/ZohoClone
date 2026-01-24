<?php

namespace App\Repository;

use App\Entity\Task;
use App\Entity\TaskAssignee;
use App\Entity\User;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<TaskAssignee>
 */
class TaskAssigneeRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, TaskAssignee::class);
    }

    public function findByTaskAndUser(Task $task, User $user): ?TaskAssignee
    {
        return $this->findOneBy(['task' => $task, 'user' => $user]);
    }

    public function isUserAssignedToTask(Task $task, User $user): bool
    {
        return $this->findByTaskAndUser($task, $user) !== null;
    }
}
