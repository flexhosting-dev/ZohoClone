import { useState } from 'react';
import { Target, MoreHorizontal, Pencil, Trash2, Loader2 } from 'lucide-react';
import { useDeleteMilestone } from '@/hooks/useMilestones';
import { useToast } from '@/hooks/useToast';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Progress } from '@/components/ui/progress';
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
import { MilestoneForm } from './MilestoneForm';
import type { Milestone } from '@/types';
import { format } from 'date-fns';

interface MilestoneListProps {
  milestones: Milestone[];
  projectId: string;
}

export function MilestoneList({ milestones, projectId }: MilestoneListProps) {
  const deleteMilestone = useDeleteMilestone();
  const { toast } = useToast();

  const [editingMilestone, setEditingMilestone] = useState<Milestone | null>(null);
  const [deletingMilestone, setDeletingMilestone] = useState<Milestone | null>(null);

  const handleDelete = async () => {
    if (!deletingMilestone) return;

    try {
      await deleteMilestone.mutateAsync({
        projectId,
        milestoneId: deletingMilestone.id,
      });
      toast({
        title: 'Milestone deleted',
        description: 'The milestone has been deleted successfully.',
      });
      setDeletingMilestone(null);
    } catch {
      toast({
        variant: 'destructive',
        title: 'Error',
        description: 'Failed to delete the milestone.',
      });
    }
  };

  if (milestones.length === 0) {
    return (
      <Card>
        <CardContent className="flex flex-col items-center justify-center py-12">
          <Target className="h-12 w-12 text-muted-foreground mb-4" />
          <h3 className="text-lg font-semibold mb-2">No milestones yet</h3>
          <p className="text-muted-foreground text-center">
            Create your first milestone to organize your tasks
          </p>
        </CardContent>
      </Card>
    );
  }

  return (
    <>
      <div className="space-y-4">
        {milestones.map((milestone) => (
          <Card key={milestone.id}>
            <CardHeader className="pb-3">
              <div className="flex items-start justify-between">
                <div>
                  <CardTitle className="text-lg">{milestone.name}</CardTitle>
                  {milestone.description && (
                    <p className="text-sm text-muted-foreground mt-1">
                      {milestone.description}
                    </p>
                  )}
                </div>
                <div className="flex items-center gap-2">
                  <Badge variant={milestone.status === 'completed' ? 'success' : 'secondary'}>
                    {milestone.status}
                  </Badge>
                  <DropdownMenu>
                    <DropdownMenuTrigger asChild>
                      <Button variant="ghost" size="icon">
                        <MoreHorizontal className="h-4 w-4" />
                      </Button>
                    </DropdownMenuTrigger>
                    <DropdownMenuContent align="end">
                      <DropdownMenuItem onClick={() => setEditingMilestone(milestone)}>
                        <Pencil className="mr-2 h-4 w-4" />
                        Edit
                      </DropdownMenuItem>
                      <DropdownMenuItem
                        className="text-destructive"
                        onClick={() => setDeletingMilestone(milestone)}
                      >
                        <Trash2 className="mr-2 h-4 w-4" />
                        Delete
                      </DropdownMenuItem>
                    </DropdownMenuContent>
                  </DropdownMenu>
                </div>
              </div>
            </CardHeader>
            <CardContent>
              <div className="space-y-3">
                <div className="flex items-center justify-between text-sm">
                  <span className="text-muted-foreground">Progress</span>
                  <span className="font-medium">{milestone.progress}%</span>
                </div>
                <Progress value={milestone.progress} className="h-2" />
                <div className="flex items-center justify-between text-sm text-muted-foreground">
                  <span>
                    {milestone.completedTaskCount} / {milestone.taskCount} tasks completed
                  </span>
                  {milestone.dueDate && (
                    <span>Due {format(new Date(milestone.dueDate), 'MMM d, yyyy')}</span>
                  )}
                </div>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>

      {/* Edit Milestone Dialog */}
      <Dialog open={!!editingMilestone} onOpenChange={() => setEditingMilestone(null)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Edit Milestone</DialogTitle>
            <DialogDescription>Update milestone details</DialogDescription>
          </DialogHeader>
          {editingMilestone && (
            <MilestoneForm
              projectId={projectId}
              milestone={editingMilestone}
              onSuccess={() => setEditingMilestone(null)}
            />
          )}
        </DialogContent>
      </Dialog>

      {/* Delete Confirmation Dialog */}
      <Dialog open={!!deletingMilestone} onOpenChange={() => setDeletingMilestone(null)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Delete Milestone</DialogTitle>
            <DialogDescription>
              Are you sure you want to delete "{deletingMilestone?.name}"? This will also delete
              all tasks within this milestone.
            </DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button variant="outline" onClick={() => setDeletingMilestone(null)}>
              Cancel
            </Button>
            <Button
              variant="destructive"
              onClick={handleDelete}
              disabled={deleteMilestone.isPending}
            >
              {deleteMilestone.isPending && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
              Delete
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </>
  );
}
