import { useState } from 'react';
import {
  DndContext,
  DragEndEvent,
  DragOverlay,
  DragStartEvent,
  closestCorners,
  PointerSensor,
  useSensor,
  useSensors,
} from '@dnd-kit/core';
import { SortableContext, verticalListSortingStrategy } from '@dnd-kit/sortable';
import { Plus, Loader2 } from 'lucide-react';
import { useUpdateTask, useDeleteTask } from '@/hooks/useTasks';
import { useToast } from '@/hooks/useToast';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog';
import { TaskForm } from './TaskForm';
import { KanbanCard } from './KanbanCard';
import type { Task, Milestone, TaskStatus } from '@/types';

const columns: { id: TaskStatus; title: string; color: string }[] = [
  { id: 'todo', title: 'To Do', color: 'bg-slate-500' },
  { id: 'in_progress', title: 'In Progress', color: 'bg-blue-500' },
  { id: 'in_review', title: 'In Review', color: 'bg-yellow-500' },
  { id: 'completed', title: 'Completed', color: 'bg-green-500' },
];

interface TaskKanbanProps {
  tasks: Task[];
  milestones: Milestone[];
  projectId: string;
}

export function TaskKanban({ tasks, milestones, projectId }: TaskKanbanProps) {
  const updateTask = useUpdateTask();
  const deleteTask = useDeleteTask();
  const { toast } = useToast();

  const [activeTask, setActiveTask] = useState<Task | null>(null);
  const [showCreateDialog, setShowCreateDialog] = useState(false);
  const [selectedMilestone, setSelectedMilestone] = useState<string | null>(null);
  const [editingTask, setEditingTask] = useState<Task | null>(null);
  const [deletingTask, setDeletingTask] = useState<Task | null>(null);

  const sensors = useSensors(
    useSensor(PointerSensor, {
      activationConstraint: {
        distance: 8,
      },
    })
  );

  const handleDragStart = (event: DragStartEvent) => {
    const task = tasks.find((t) => t.id === event.active.id);
    if (task) {
      setActiveTask(task);
    }
  };

  const handleDragEnd = async (event: DragEndEvent) => {
    const { active, over } = event;
    setActiveTask(null);

    if (!over) return;

    const taskId = active.id as string;
    const newStatus = over.id as TaskStatus;

    const task = tasks.find((t) => t.id === taskId);
    if (!task || task.status === newStatus) return;

    try {
      await updateTask.mutateAsync({
        milestoneId: task.milestone.id,
        taskId: task.id,
        data: { status: newStatus },
      });
      toast({
        title: 'Task updated',
        description: `Task moved to ${newStatus.replace('_', ' ')}`,
      });
    } catch {
      toast({
        variant: 'destructive',
        title: 'Error',
        description: 'Failed to update task status.',
      });
    }
  };

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

  const openCreateDialog = () => {
    if (milestones.length > 0) {
      setSelectedMilestone(milestones[0].id);
      setShowCreateDialog(true);
    }
  };

  const getTasksByStatus = (status: TaskStatus) => {
    return tasks.filter((task) => task.status === status);
  };

  return (
    <DndContext
      sensors={sensors}
      collisionDetection={closestCorners}
      onDragStart={handleDragStart}
      onDragEnd={handleDragEnd}
    >
      <div className="flex gap-4 overflow-x-auto pb-4">
        {columns.map((column) => {
          const columnTasks = getTasksByStatus(column.id);

          return (
            <div key={column.id} className="flex-shrink-0 w-72">
              <Card className="h-full">
                <CardHeader className="pb-3">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-2">
                      <div className={`w-3 h-3 rounded-full ${column.color}`} />
                      <CardTitle className="text-sm font-medium">{column.title}</CardTitle>
                      <Badge variant="secondary" className="text-xs">
                        {columnTasks.length}
                      </Badge>
                    </div>
                    {column.id === 'todo' && (
                      <Button size="sm" variant="ghost" onClick={openCreateDialog}>
                        <Plus className="h-4 w-4" />
                      </Button>
                    )}
                  </div>
                </CardHeader>
                <CardContent className="space-y-2 min-h-[200px]">
                  <SortableContext
                    id={column.id}
                    items={columnTasks.map((t) => t.id)}
                    strategy={verticalListSortingStrategy}
                  >
                    {columnTasks.map((task) => (
                      <KanbanCard
                        key={task.id}
                        task={task}
                        onEdit={() => setEditingTask(task)}
                        onDelete={() => setDeletingTask(task)}
                      />
                    ))}
                  </SortableContext>
                  {columnTasks.length === 0 && (
                    <div
                      className="flex items-center justify-center h-24 text-sm text-muted-foreground border-2 border-dashed rounded-lg"
                    >
                      Drop tasks here
                    </div>
                  )}
                </CardContent>
              </Card>
            </div>
          );
        })}
      </div>

      <DragOverlay>
        {activeTask && (
          <div className="opacity-80">
            <KanbanCard task={activeTask} />
          </div>
        )}
      </DragOverlay>

      {/* Create Task Dialog */}
      <Dialog open={showCreateDialog} onOpenChange={setShowCreateDialog}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Create Task</DialogTitle>
            <DialogDescription>Add a new task</DialogDescription>
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
    </DndContext>
  );
}
