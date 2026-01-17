import { useState } from 'react';
import { Plus, CheckSquare, MoreHorizontal, Pencil, Trash2, Loader2 } from 'lucide-react';
import { useDeleteTask } from '@/hooks/useTasks';
import { useToast } from '@/hooks/useToast';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog';
import { TaskForm } from './TaskForm';
import { TaskCard } from './TaskCard';
import type { Task, Milestone } from '@/types';

interface TaskListProps {
  tasks: Task[];
  milestones: Milestone[];
  projectId: string;
}

export function TaskList({ tasks, milestones, projectId }: TaskListProps) {
  const deleteTask = useDeleteTask();
  const { toast } = useToast();

  const [showCreateDialog, setShowCreateDialog] = useState(false);
  const [selectedMilestone, setSelectedMilestone] = useState<string | null>(null);
  const [editingTask, setEditingTask] = useState<Task | null>(null);
  const [deletingTask, setDeletingTask] = useState<Task | null>(null);

  const handleDelete = async () => {
    if (!deletingTask) return;

    try {
      await deleteTask.mutateAsync({
        milestoneId: deletingTask.milestone.id,
        taskId: deletingTask.id,
        projectId,
      });
      toast({
        title: 'Task deleted',
        description: 'The task has been deleted successfully.',
      });
      setDeletingTask(null);
    } catch {
      toast({
        variant: 'destructive',
        title: 'Error',
        description: 'Failed to delete the task.',
      });
    }
  };

  const openCreateDialog = (milestoneId: string) => {
    setSelectedMilestone(milestoneId);
    setShowCreateDialog(true);
  };

  // Group tasks by milestone
  const tasksByMilestone = milestones.map((milestone) => ({
    milestone,
    tasks: tasks.filter((task) => task.milestone.id === milestone.id),
  }));

  if (tasks.length === 0 && milestones.length > 0) {
    return (
      <div className="space-y-4">
        {milestones.map((milestone) => (
          <Card key={milestone.id}>
            <CardHeader className="pb-3">
              <div className="flex items-center justify-between">
                <CardTitle className="text-lg">{milestone.name}</CardTitle>
                <Button size="sm" onClick={() => openCreateDialog(milestone.id)}>
                  <Plus className="h-4 w-4 mr-2" />
                  Add Task
                </Button>
              </div>
            </CardHeader>
            <CardContent>
              <div className="flex flex-col items-center justify-center py-8 text-center">
                <CheckSquare className="h-8 w-8 text-muted-foreground mb-2" />
                <p className="text-sm text-muted-foreground">No tasks in this milestone</p>
              </div>
            </CardContent>
          </Card>
        ))}

        <Dialog open={showCreateDialog} onOpenChange={setShowCreateDialog}>
          <DialogContent>
            <DialogHeader>
              <DialogTitle>Create Task</DialogTitle>
              <DialogDescription>Add a new task to the milestone</DialogDescription>
            </DialogHeader>
            {selectedMilestone && (
              <TaskForm
                milestoneId={selectedMilestone}
                onSuccess={() => {
                  setShowCreateDialog(false);
                  setSelectedMilestone(null);
                }}
              />
            )}
          </DialogContent>
        </Dialog>
      </div>
    );
  }

  return (
    <div className="space-y-4">
      {tasksByMilestone.map(({ milestone, tasks: milestoneTasks }) => (
        <Card key={milestone.id}>
          <CardHeader className="pb-3">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2">
                <CardTitle className="text-lg">{milestone.name}</CardTitle>
                <Badge variant="secondary">{milestoneTasks.length} tasks</Badge>
              </div>
              <Button size="sm" onClick={() => openCreateDialog(milestone.id)}>
                <Plus className="h-4 w-4 mr-2" />
                Add Task
              </Button>
            </div>
          </CardHeader>
          <CardContent>
            {milestoneTasks.length > 0 ? (
              <div className="space-y-2">
                {milestoneTasks.map((task) => (
                  <TaskCard
                    key={task.id}
                    task={task}
                    onEdit={() => setEditingTask(task)}
                    onDelete={() => setDeletingTask(task)}
                  />
                ))}
              </div>
            ) : (
              <div className="flex flex-col items-center justify-center py-8 text-center">
                <CheckSquare className="h-8 w-8 text-muted-foreground mb-2" />
                <p className="text-sm text-muted-foreground">No tasks in this milestone</p>
              </div>
            )}
          </CardContent>
        </Card>
      ))}

      {/* Create Task Dialog */}
      <Dialog open={showCreateDialog} onOpenChange={setShowCreateDialog}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Create Task</DialogTitle>
            <DialogDescription>Add a new task to the milestone</DialogDescription>
          </DialogHeader>
          {selectedMilestone && (
            <TaskForm
              milestoneId={selectedMilestone}
              onSuccess={() => {
                setShowCreateDialog(false);
                setSelectedMilestone(null);
              }}
            />
          )}
        </DialogContent>
      </Dialog>

      {/* Edit Task Dialog */}
      <Dialog open={!!editingTask} onOpenChange={() => setEditingTask(null)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Edit Task</DialogTitle>
            <DialogDescription>Update task details</DialogDescription>
          </DialogHeader>
          {editingTask && (
            <TaskForm
              milestoneId={editingTask.milestone.id}
              task={editingTask}
              onSuccess={() => setEditingTask(null)}
            />
          )}
        </DialogContent>
      </Dialog>

      {/* Delete Confirmation Dialog */}
      <Dialog open={!!deletingTask} onOpenChange={() => setDeletingTask(null)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Delete Task</DialogTitle>
            <DialogDescription>
              Are you sure you want to delete "{deletingTask?.title}"? This action cannot be undone.
            </DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button variant="outline" onClick={() => setDeletingTask(null)}>
              Cancel
            </Button>
            <Button
              variant="destructive"
              onClick={handleDelete}
              disabled={deleteTask.isPending}
            >
              {deleteTask.isPending && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
              Delete
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}
