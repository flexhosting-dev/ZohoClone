import { useSortable } from '@dnd-kit/sortable';
import { CSS } from '@dnd-kit/utilities';
import { Calendar, MessageSquare, MoreHorizontal, Pencil, Trash2, GripVertical } from 'lucide-react';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Avatar, AvatarFallback } from '@/components/ui/avatar';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import { cn } from '@/utils/cn';
import type { Task } from '@/types';
import { format } from 'date-fns';

const priorityColors = {
  low: 'bg-slate-100 text-slate-700',
  medium: 'bg-blue-100 text-blue-700',
  high: 'bg-orange-100 text-orange-700',
  urgent: 'bg-red-100 text-red-700',
} as const;

interface KanbanCardProps {
  task: Task;
  onEdit?: () => void;
  onDelete?: () => void;
}

export function KanbanCard({ task, onEdit, onDelete }: KanbanCardProps) {
  const {
    attributes,
    listeners,
    setNodeRef,
    transform,
    transition,
    isDragging,
  } = useSortable({ id: task.id });

  const style = {
    transform: CSS.Transform.toString(transform),
    transition,
  };

  const getInitials = (firstName: string, lastName: string) => {
    return `${firstName.charAt(0)}${lastName.charAt(0)}`.toUpperCase();
  };

  return (
    <div
      ref={setNodeRef}
      style={style}
      className={cn(
        'rounded-lg border bg-card p-3 shadow-sm cursor-grab active:cursor-grabbing',
        isDragging && 'opacity-50 shadow-lg',
        task.isOverdue && 'border-destructive/50'
      )}
    >
      <div className="flex items-start gap-2">
        <div
          {...attributes}
          {...listeners}
          className="text-muted-foreground hover:text-foreground cursor-grab mt-0.5"
        >
          <GripVertical className="h-4 w-4" />
        </div>

        <div className="flex-1 min-w-0">
          <div className="flex items-start justify-between mb-2">
            <h4 className="font-medium text-sm truncate pr-2">{task.title}</h4>
            {(onEdit || onDelete) && (
              <DropdownMenu>
                <DropdownMenuTrigger asChild>
                  <Button variant="ghost" size="icon" className="h-6 w-6 -mr-1 -mt-1">
                    <MoreHorizontal className="h-3 w-3" />
                  </Button>
                </DropdownMenuTrigger>
                <DropdownMenuContent align="end">
                  {onEdit && (
                    <DropdownMenuItem onClick={onEdit}>
                      <Pencil className="mr-2 h-4 w-4" />
                      Edit
                    </DropdownMenuItem>
                  )}
                  {onDelete && (
                    <DropdownMenuItem className="text-destructive" onClick={onDelete}>
                      <Trash2 className="mr-2 h-4 w-4" />
                      Delete
                    </DropdownMenuItem>
                  )}
                </DropdownMenuContent>
              </DropdownMenu>
            )}
          </div>

          <div className="flex flex-wrap gap-1 mb-2">
            <Badge className={cn('text-xs', priorityColors[task.priority])}>
              {task.priority}
            </Badge>
          </div>

          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3 text-xs text-muted-foreground">
              {task.dueDate && (
                <span className={cn('flex items-center gap-1', task.isOverdue && 'text-destructive')}>
                  <Calendar className="h-3 w-3" />
                  {format(new Date(task.dueDate), 'MMM d')}
                </span>
              )}
              {task.commentCount > 0 && (
                <span className="flex items-center gap-1">
                  <MessageSquare className="h-3 w-3" />
                  {task.commentCount}
                </span>
              )}
            </div>

            {task.assignees && task.assignees.length > 0 && (
              <div className="flex -space-x-1">
                {task.assignees.slice(0, 2).map((assignee) => (
                  <Avatar key={assignee.id} className="h-5 w-5 border border-background">
                    <AvatarFallback className="text-[10px]">
                      {getInitials(assignee.user.firstName, assignee.user.lastName)}
                    </AvatarFallback>
                  </Avatar>
                ))}
                {task.assignees.length > 2 && (
                  <Avatar className="h-5 w-5 border border-background">
                    <AvatarFallback className="text-[10px]">
                      +{task.assignees.length - 2}
                    </AvatarFallback>
                  </Avatar>
                )}
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
