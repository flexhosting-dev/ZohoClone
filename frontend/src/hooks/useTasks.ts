import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { tasksService } from '@/services/tasks';
import type { CreateTaskData, UpdateTaskData } from '@/types';

export function useTasks(milestoneId: string) {
  return useQuery({
    queryKey: ['milestones', milestoneId, 'tasks'],
    queryFn: () => tasksService.getTasks(milestoneId),
    enabled: !!milestoneId,
  });
}

export function useProjectTasks(projectId: string) {
  return useQuery({
    queryKey: ['projects', projectId, 'tasks'],
    queryFn: () => tasksService.getProjectTasks(projectId),
    enabled: !!projectId,
  });
}

export function useMyTasks() {
  return useQuery({
    queryKey: ['my-tasks'],
    queryFn: tasksService.getMyTasks,
  });
}

export function useTask(milestoneId: string, taskId: string) {
  return useQuery({
    queryKey: ['milestones', milestoneId, 'tasks', taskId],
    queryFn: () => tasksService.getTask(milestoneId, taskId),
    enabled: !!milestoneId && !!taskId,
  });
}

export function useCreateTask() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ milestoneId, data }: { milestoneId: string; data: CreateTaskData }) =>
      tasksService.createTask(milestoneId, data),
    onSuccess: (task, { milestoneId }) => {
      queryClient.invalidateQueries({ queryKey: ['milestones', milestoneId, 'tasks'] });
      queryClient.invalidateQueries({ queryKey: ['projects', task.project.id, 'tasks'] });
      queryClient.invalidateQueries({ queryKey: ['projects', task.project.id, 'milestones'] });
      queryClient.invalidateQueries({ queryKey: ['my-tasks'] });
      queryClient.invalidateQueries({ queryKey: ['dashboard'] });
    },
  });
}

export function useUpdateTask() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ milestoneId, taskId, data }: { milestoneId: string; taskId: string; data: UpdateTaskData }) =>
      tasksService.updateTask(milestoneId, taskId, data),
    onSuccess: (task, { milestoneId, taskId }) => {
      queryClient.invalidateQueries({ queryKey: ['milestones', milestoneId, 'tasks'] });
      queryClient.invalidateQueries({ queryKey: ['milestones', milestoneId, 'tasks', taskId] });
      queryClient.invalidateQueries({ queryKey: ['projects', task.project.id, 'tasks'] });
      queryClient.invalidateQueries({ queryKey: ['my-tasks'] });
      queryClient.invalidateQueries({ queryKey: ['dashboard'] });
    },
  });
}

export function useDeleteTask() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ milestoneId, taskId, projectId }: { milestoneId: string; taskId: string; projectId: string }) =>
      tasksService.deleteTask(milestoneId, taskId),
    onSuccess: (_, { milestoneId, projectId }) => {
      queryClient.invalidateQueries({ queryKey: ['milestones', milestoneId, 'tasks'] });
      queryClient.invalidateQueries({ queryKey: ['projects', projectId, 'tasks'] });
      queryClient.invalidateQueries({ queryKey: ['projects', projectId, 'milestones'] });
      queryClient.invalidateQueries({ queryKey: ['my-tasks'] });
      queryClient.invalidateQueries({ queryKey: ['dashboard'] });
    },
  });
}

export function useAssignUser() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ taskId, userId }: { taskId: string; userId: string; milestoneId: string }) =>
      tasksService.assignUser(taskId, userId),
    onSuccess: (_, { milestoneId }) => {
      queryClient.invalidateQueries({ queryKey: ['milestones', milestoneId, 'tasks'] });
      queryClient.invalidateQueries({ queryKey: ['my-tasks'] });
    },
  });
}

export function useUnassignUser() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ taskId, assigneeId }: { taskId: string; assigneeId: string; milestoneId: string }) =>
      tasksService.unassignUser(taskId, assigneeId),
    onSuccess: (_, { milestoneId }) => {
      queryClient.invalidateQueries({ queryKey: ['milestones', milestoneId, 'tasks'] });
      queryClient.invalidateQueries({ queryKey: ['my-tasks'] });
    },
  });
}
