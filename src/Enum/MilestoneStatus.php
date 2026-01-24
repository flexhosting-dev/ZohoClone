<?php

namespace App\Enum;

enum MilestoneStatus: string
{
    case OPEN = 'open';
    case COMPLETED = 'completed';

    public function label(): string
    {
        return match($this) {
            self::OPEN => 'Open',
            self::COMPLETED => 'Completed',
        };
    }
}
