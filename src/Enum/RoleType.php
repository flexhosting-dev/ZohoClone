<?php

namespace App\Enum;

enum RoleType: string
{
    case PORTAL = 'portal';   // Portal-wide roles (SuperAdmin, Admin)
    case PROJECT = 'project'; // Project-specific roles (Manager, Member, Viewer)

    public function label(): string
    {
        return match ($this) {
            self::PORTAL => 'Portal Role',
            self::PROJECT => 'Project Role',
        };
    }
}
