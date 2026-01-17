<?php

namespace App\Enum;

enum ProjectRole: string
{
    case ADMIN = 'admin';
    case MEMBER = 'member';
    case VIEWER = 'viewer';

    public function label(): string
    {
        return match($this) {
            self::ADMIN => 'Admin',
            self::MEMBER => 'Member',
            self::VIEWER => 'Viewer',
        };
    }

    public function canEdit(): bool
    {
        return match($this) {
            self::ADMIN, self::MEMBER => true,
            self::VIEWER => false,
        };
    }

    public function canManageMembers(): bool
    {
        return $this === self::ADMIN;
    }

    public function canDelete(): bool
    {
        return $this === self::ADMIN;
    }
}
