<?php

namespace App\DTO;

use App\Enum\TaskPriority;
use App\Enum\TaskStatus;
use Symfony\Component\HttpFoundation\Request;

class TaskFilterDTO
{
    public function __construct(
        public readonly array $statuses = [],
        public readonly array $priorities = [],
        public readonly array $assigneeIds = [],
        public readonly array $milestoneIds = [],
        public readonly ?string $dueFilter = null,
        public readonly ?string $dueDateFrom = null,
        public readonly ?string $dueDateTo = null,
        public readonly ?string $search = null,
        public readonly array $projectIds = [],
    ) {
    }

    public static function fromRequest(Request $request): self
    {
        $statuses = [];
        $statusParam = $request->query->get('status', '');
        if ($statusParam) {
            $statusValues = explode(',', $statusParam);
            foreach ($statusValues as $value) {
                $status = TaskStatus::tryFrom($value);
                if ($status) {
                    $statuses[] = $status;
                }
            }
        }

        $priorities = [];
        $priorityParam = $request->query->get('priority', '');
        if ($priorityParam) {
            $priorityValues = explode(',', $priorityParam);
            foreach ($priorityValues as $value) {
                $priority = TaskPriority::tryFrom($value);
                if ($priority) {
                    $priorities[] = $priority;
                }
            }
        }

        $assigneeIds = [];
        $assigneeParam = $request->query->get('assignee', '');
        if ($assigneeParam) {
            $assigneeIds = array_filter(explode(',', $assigneeParam));
        }

        $milestoneIds = [];
        $milestoneParam = $request->query->get('milestone', '');
        if ($milestoneParam) {
            $milestoneIds = array_filter(explode(',', $milestoneParam));
        }

        $projectIds = [];
        $projectParam = $request->query->get('project', '');
        if ($projectParam) {
            $projectIds = array_filter(explode(',', $projectParam));
        }

        $dueFilter = $request->query->get('due');
        $dueDateFrom = null;
        $dueDateTo = null;

        if ($dueFilter === 'custom') {
            $dueDateFrom = $request->query->get('due_from');
            $dueDateTo = $request->query->get('due_to');
        }

        $search = $request->query->get('search');

        return new self(
            statuses: $statuses,
            priorities: $priorities,
            assigneeIds: $assigneeIds,
            milestoneIds: $milestoneIds,
            dueFilter: $dueFilter,
            dueDateFrom: $dueDateFrom,
            dueDateTo: $dueDateTo,
            search: $search ?: null,
            projectIds: $projectIds,
        );
    }

    public function hasActiveFilters(): bool
    {
        return !empty($this->statuses)
            || !empty($this->priorities)
            || !empty($this->assigneeIds)
            || !empty($this->milestoneIds)
            || $this->dueFilter !== null
            || $this->search !== null
            || !empty($this->projectIds);
    }

    public function getActiveFilterCount(): int
    {
        $count = 0;
        if (!empty($this->statuses)) $count++;
        if (!empty($this->priorities)) $count++;
        if (!empty($this->assigneeIds)) $count++;
        if (!empty($this->milestoneIds)) $count++;
        if ($this->dueFilter !== null) $count++;
        if ($this->search !== null) $count++;
        if (!empty($this->projectIds)) $count++;
        return $count;
    }

    public function toQueryParams(): array
    {
        $params = [];

        if (!empty($this->statuses)) {
            $params['status'] = implode(',', array_map(fn($s) => $s->value, $this->statuses));
        }
        if (!empty($this->priorities)) {
            $params['priority'] = implode(',', array_map(fn($p) => $p->value, $this->priorities));
        }
        if (!empty($this->assigneeIds)) {
            $params['assignee'] = implode(',', $this->assigneeIds);
        }
        if (!empty($this->milestoneIds)) {
            $params['milestone'] = implode(',', $this->milestoneIds);
        }
        if ($this->dueFilter) {
            $params['due'] = $this->dueFilter;
            if ($this->dueFilter === 'custom') {
                if ($this->dueDateFrom) $params['due_from'] = $this->dueDateFrom;
                if ($this->dueDateTo) $params['due_to'] = $this->dueDateTo;
            }
        }
        if ($this->search) {
            $params['search'] = $this->search;
        }
        if (!empty($this->projectIds)) {
            $params['project'] = implode(',', $this->projectIds);
        }

        return $params;
    }
}
