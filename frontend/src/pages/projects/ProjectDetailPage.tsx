import { useState, useEffect } from 'react';
import { useParams, Link, useSearchParams } from 'react-router-dom';
import {
  Plus,
  Loader2,
  ChevronLeft,
  LayoutList,
  LayoutDashboard,
  Users,
  Target,
  Activity
} from 'lucide-react';
import { useProject } from '@/hooks/useProjects';
import { useMilestones } from '@/hooks/useMilestones';
import { useProjectTasks } from '@/hooks/useTasks';
import { useProjectActivities } from '@/hooks/useDashboard';
import { useUIStore } from '@/stores/uiStore';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle } from '@/components/ui/dialog';
import { MilestoneList } from '@/components/milestones/MilestoneList';
import { MilestoneForm } from '@/components/milestones/MilestoneForm';
import { TaskList } from '@/components/tasks/TaskList';
import { TaskKanban } from '@/components/tasks/TaskKanban';
import { ActivityFeed } from '@/components/common/ActivityFeed';
import { format } from 'date-fns';

const statusColors = {
  active: 'success',
  on_hold: 'warning',
  completed: 'secondary',
  archived: 'outline',
} as const;

export function ProjectDetailPage() {
  const { projectId } = useParams<{ projectId: string }>();
  const [searchParams, setSearchParams] = useSearchParams();
  const { taskViewMode, setTaskViewMode } = useUIStore();
  const [showMilestoneDialog, setShowMilestoneDialog] = useState(false);

  // Sync view mode with URL
  const urlView = searchParams.get('view') as 'list' | 'kanban' | null;
  const currentView = urlView || taskViewMode;

  useEffect(() => {
    // If URL has a view param, sync it to store
    if (urlView && urlView !== taskViewMode) {
      setTaskViewMode(urlView);
    }
  }, [urlView, taskViewMode, setTaskViewMode]);

  const handleViewModeChange = (mode: 'list' | 'kanban') => {
    const newParams = new URLSearchParams(searchParams);
    newParams.set('view', mode);
    setSearchParams(newParams, { replace: false });
    setTaskViewMode(mode);
  };

  const { data: project, isLoading: isLoadingProject } = useProject(projectId!);
  const { data: milestones, isLoading: isLoadingMilestones } = useMilestones(projectId!);
  const { data: tasks, isLoading: isLoadingTasks } = useProjectTasks(projectId!);
  const { data: activities } = useProjectActivities(projectId!);

  if (isLoadingProject) {
    return (
      <div className="flex items-center justify-center h-96">
        <Loader2 className="h-8 w-8 animate-spin text-primary" />
      </div>
    );
  }

  if (!project) {
    return (
      <div className="text-center py-12">
        <h2 className="text-2xl font-bold">Project not found</h2>
        <Button asChild className="mt-4">
          <Link to="/projects">Back to Projects</Link>
        </Button>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-start justify-between">
        <div className="space-y-1">
          <div className="flex items-center gap-2">
            <Button variant="ghost" size="icon" asChild>
              <Link to="/projects">
                <ChevronLeft className="h-4 w-4" />
              </Link>
            </Button>
            <h1 className="text-3xl font-bold">{project.name}</h1>
            <Badge variant={statusColors[project.status]}>
              {project.status.replace('_', ' ')}
            </Badge>
          </div>
          {project.description && (
            <p className="text-muted-foreground ml-10">{project.description}</p>
          )}
          <div className="flex items-center gap-4 text-sm text-muted-foreground ml-10">
            {project.startDate && (
              <span>Started: {format(new Date(project.startDate), 'MMM d, yyyy')}</span>
            )}
            {project.endDate && (
              <span>Due: {format(new Date(project.endDate), 'MMM d, yyyy')}</span>
            )}
            <span>{project.memberCount} {project.memberCount === 1 ? 'member' : 'members'}</span>
          </div>
        </div>
      </div>

      {/* Tabs */}
      <Tabs defaultValue="tasks" className="space-y-4">
        <TabsList>
          <TabsTrigger value="tasks" className="gap-2">
            <LayoutList className="h-4 w-4" />
            Tasks
          </TabsTrigger>
          <TabsTrigger value="milestones" className="gap-2">
            <Target className="h-4 w-4" />
            Milestones
          </TabsTrigger>
          <TabsTrigger value="members" className="gap-2">
            <Users className="h-4 w-4" />
            Members
          </TabsTrigger>
          <TabsTrigger value="activity" className="gap-2">
            <Activity className="h-4 w-4" />
            Activity
          </TabsTrigger>
        </TabsList>

        {/* Tasks Tab */}
        <TabsContent value="tasks" className="space-y-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-2">
              <Button
                variant={currentView === 'list' ? 'default' : 'outline'}
                size="sm"
                onClick={() => handleViewModeChange('list')}
              >
                <LayoutList className="h-4 w-4 mr-2" />
                List
              </Button>
              <Button
                variant={currentView === 'kanban' ? 'default' : 'outline'}
                size="sm"
                onClick={() => handleViewModeChange('kanban')}
              >
                <LayoutDashboard className="h-4 w-4 mr-2" />
                Kanban
              </Button>
            </div>
          </div>

          {isLoadingTasks || isLoadingMilestones ? (
            <div className="flex items-center justify-center h-48">
              <Loader2 className="h-6 w-6 animate-spin text-primary" />
            </div>
          ) : milestones && milestones.length > 0 ? (
            currentView === 'list' ? (
              <TaskList
                tasks={tasks || []}
                milestones={milestones}
                projectId={projectId!}
              />
            ) : (
              <TaskKanban
                tasks={tasks || []}
                milestones={milestones}
                projectId={projectId!}
              />
            )
          ) : (
            <div className="text-center py-12 bg-muted/30 rounded-lg">
              <Target className="h-12 w-12 text-muted-foreground mx-auto mb-4" />
              <h3 className="text-lg font-semibold mb-2">No milestones yet</h3>
              <p className="text-muted-foreground mb-4">
                Create a milestone first to start adding tasks
              </p>
              <Button onClick={() => setShowMilestoneDialog(true)}>
                <Plus className="mr-2 h-4 w-4" />
                Create Milestone
              </Button>
            </div>
          )}
        </TabsContent>

        {/* Milestones Tab */}
        <TabsContent value="milestones" className="space-y-4">
          <div className="flex justify-end">
            <Button onClick={() => setShowMilestoneDialog(true)}>
              <Plus className="mr-2 h-4 w-4" />
              New Milestone
            </Button>
          </div>

          {isLoadingMilestones ? (
            <div className="flex items-center justify-center h-48">
              <Loader2 className="h-6 w-6 animate-spin text-primary" />
            </div>
          ) : (
            <MilestoneList milestones={milestones || []} projectId={projectId!} />
          )}
        </TabsContent>

        {/* Members Tab */}
        <TabsContent value="members" className="space-y-4">
          <div className="bg-muted/30 rounded-lg p-8 text-center">
            <Users className="h-12 w-12 text-muted-foreground mx-auto mb-4" />
            <h3 className="text-lg font-semibold mb-2">Team Members</h3>
            <p className="text-muted-foreground">
              {project.members?.map(m => m.user.fullName).join(', ') || 'No members'}
            </p>
          </div>
        </TabsContent>

        {/* Activity Tab */}
        <TabsContent value="activity">
          <ActivityFeed activities={activities || []} />
        </TabsContent>
      </Tabs>

      {/* Create Milestone Dialog */}
      <Dialog open={showMilestoneDialog} onOpenChange={setShowMilestoneDialog}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Create Milestone</DialogTitle>
            <DialogDescription>Add a new milestone to organize your tasks</DialogDescription>
          </DialogHeader>
          <MilestoneForm
            projectId={projectId!}
            onSuccess={() => setShowMilestoneDialog(false)}
          />
        </DialogContent>
      </Dialog>
    </div>
  );
}
