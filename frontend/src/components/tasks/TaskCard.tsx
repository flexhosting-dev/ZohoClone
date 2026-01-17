import { Calendar, MessageSquare, MoreHorizontal, Pencil, Trash2 } from 'lucide-react';
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

const statusColors = {
  todo: 'secondary',
  in_progress: 'default',
  in_review: 'warning',
  completed: 'success',
} as const;

const priorityColors = {
  low: 'secondary',
  medium: 'default',
  high: 'warning',
  urgent: 'destructive',
} as const;

interface TaskCardProps {
  task: Task;
  onEdit?: () => void;
  onDelete?: () => void;
  compact?: boolean;
}

export function TaskCard({ task, onEdit, onDelete, compact = false }: TaskCardProps) {
  const getInitials = (firstName: string, lastName: string) => {
    return `${firstName.charAt(0)}${lastName.charAt(0)}`.toUpperCase();
  };

  return (
    <div
      className={cn(
        'flex items-center justify-between rounded-lg border bg-card p-3 hover:bg-accent/50 transition-colors',
        task.isOverdue && 'border-destructive/50'
      )}
    >
      <div className="flex-1 min-w-0">
        <div className="flex items-center gap-2 mb-1">
          <h4 className="font-medium truncate">{task.title}</h4>
          {!compact && (
            <>
              <Badge variant={statusColors[task.status]} className="text-xs">
                {task.status.replace('_', ' ')}
              </Badge>
              <Badge variant={priorityColors[task.priority]} className="text-xs">
                {task.priority}
              </Badge>
            </>
          )}
        </div>

        {!compact && (
          <div className="flex items-center gap-4 text-xs text-muted-foreground">
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
        )}
      </div>

      <div className="flex items-center gap-2">
        {/* Assignees */}
        {task.assignees && task.assignees.length > 0 && (
          <div className="flex -space-x-2">
            {task.assignees.slice(0, 3).map((assignee) => (
              <Avatar key={assignee.id} className="h-6 w-6 border-2 border-background">
                <AvatarFallback className="text-xs">
                  {getInitials(assignee.user.firstName, assignee.user.lastName)}
                </AvatarFallback>
              </Avatar>
            ))}
            {task.assignees.length > 3 && (
              <Avatar className="h-6 w-6 border-2 border-background">
                <AvatarFallback className="text-xs">
                  +{task.assignees.length - 3}
                </AvatarFallback>
              </Avatar>
            )}
          </div>
        )}

        {/* Actions */}
        {(onEdit || onDelete) && (
          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button variant="ghost" size="icon" className="h-8 w-8">
                <MoreHorizontal className="h-4 w-4" />
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
    </div>
  );
}
