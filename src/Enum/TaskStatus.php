<?php

namespace App\Enum;

enum TaskStatus: string
{
    case TODO = 'todo';
    case IN_PROGRESS = 'in_progress';
    case IN_REVIEW = 'in_review';
    case COMPLETED = 'completed';

    public function label(): string
    {
        return match($this) {
            self::TODO => 'To Do',
            self::IN_PROGRESS => 'In Progress',
            self::IN_REVIEW => 'In Review',
            self::COMPLETED => 'Completed',
        };
    }

    public function order(): int
    {
        return match($this) {
            self::TODO => 0,
            self::IN_PROGRESS => 1,
            self::IN_REVIEW => 2,
            self::COMPLETED => 3,
        };
    }
}
