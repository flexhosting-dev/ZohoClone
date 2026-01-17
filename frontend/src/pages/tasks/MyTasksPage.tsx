import { Link } from 'react-router-dom';
import { CheckSquare, Loader2, Calendar, FolderKanban } from 'lucide-react';
import { useMyTasks } from '@/hooks/useTasks';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { cn } from '@/utils/cn';
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

export function MyTasksPage() {
  const { data: tasks, isLoading } = useMyTasks();

  if (isLoading) {
    return (
      <div className="flex items-center justify-center h-96">
        <Loader2 className="h-8 w-8 animate-spin text-primary" />
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold">My Tasks</h1>
        <p className="text-muted-foreground">All tasks assigned to you across projects</p>
      </div>

      {tasks && tasks.length > 0 ? (
        <div className="space-y-3">
          {tasks.map((task) => (
            <Card key={task.id} className={cn(task.isOverdue && 'border-destructive/50')}>
              <CardContent className="p-4">
                <div className="flex items-center justify-between">
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-2 mb-1">
                      <h3 className="font-medium truncate">{task.title}</h3>
                      <Badge variant={statusColors[task.status]} className="text-xs">
                        {task.status.replace('_', ' ')}
                      </Badge>
                      <Badge variant={priorityColors[task.priority]} className="text-xs">
                        {task.priority}
                      </Badge>
                    </div>
                    <div className="flex items-center gap-4 text-sm text-muted-foreground">
                      <Link
                        to={`/projects/${task.project.id}`}
                        className="flex items-center gap-1 hover:text-primary transition-colors"
                      >
                        <FolderKanban className="h-3 w-3" />
                        {task.project.name}
                      </Link>
                      {task.milestone && (
                        <span className="text-xs">
                          {task.milestone.name}
                        </span>
                      )}
                    </div>
                  </div>

                  <div className="flex items-center gap-4">
                    {task.dueDate && (
                      <span
                        className={cn(
                          'flex items-center gap-1 text-sm',
                          task.isOverdue ? 'text-destructive' : 'text-muted-foreground'
                        )}
                      >
                        <Calendar className="h-4 w-4" />
                        {format(new Date(task.dueDate), 'MMM d, yyyy')}
                      </span>
                    )}
                  </div>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      ) : (
        <Card>
          <CardContent className="flex flex-col items-center justify-center py-12">
            <CheckSquare className="h-12 w-12 text-muted-foreground mb-4" />
            <h3 className="text-lg font-semibold mb-2">No tasks assigned</h3>
            <p className="text-muted-foreground text-center">
              You don't have any tasks assigned yet. Tasks assigned to you will appear here.
            </p>
          </CardContent>
        </Card>
      )}
    </div>
  );
}
