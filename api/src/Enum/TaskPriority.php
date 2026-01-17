<?php

namespace App\Enum;

enum TaskPriority: string
{
    case LOW = 'low';
    case MEDIUM = 'medium';
    case HIGH = 'high';
    case URGENT = 'urgent';

    public function label(): string
    {
        return match($this) {
            self::LOW => 'Low',
            self::MEDIUM => 'Medium',
            self::HIGH => 'High',
            self::URGENT => 'Urgent',
        };
    }

    public function order(): int
    {
        return match($this) {
            self::LOW => 0,
            self::MEDIUM => 1,
            self::HIGH => 2,
            self::URGENT => 3,
        };
    }
}
