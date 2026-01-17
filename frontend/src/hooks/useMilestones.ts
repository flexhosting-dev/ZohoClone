import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { milestonesService } from '@/services/milestones';
import type { CreateMilestoneData, UpdateMilestoneData } from '@/types';

export function useMilestones(projectId: string) {
  return useQuery({
    queryKey: ['projects', projectId, 'milestones'],
    queryFn: () => milestonesService.getMilestones(projectId),
    enabled: !!projectId,
  });
}

export function useMilestone(projectId: string, milestoneId: string) {
  return useQuery({
    queryKey: ['projects', projectId, 'milestones', milestoneId],
    queryFn: () => milestonesService.getMilestone(projectId, milestoneId),
    enabled: !!projectId && !!milestoneId,
  });
}

export function useCreateMilestone() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ projectId, data }: { projectId: string; data: CreateMilestoneData }) =>
      milestonesService.createMilestone(projectId, data),
    onSuccess: (_, { projectId }) => {
      queryClient.invalidateQueries({ queryKey: ['projects', projectId, 'milestones'] });
      queryClient.invalidateQueries({ queryKey: ['projects', projectId] });
    },
  });
}

export function useUpdateMilestone() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ projectId, milestoneId, data }: { projectId: string; milestoneId: string; data: UpdateMilestoneData }) =>
      milestonesService.updateMilestone(projectId, milestoneId, data),
    onSuccess: (_, { projectId, milestoneId }) => {
      queryClient.invalidateQueries({ queryKey: ['projects', projectId, 'milestones'] });
      queryClient.invalidateQueries({ queryKey: ['projects', projectId, 'milestones', milestoneId] });
    },
  });
}

export function useDeleteMilestone() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ projectId, milestoneId }: { projectId: string; milestoneId: string }) =>
      milestonesService.deleteMilestone(projectId, milestoneId),
    onSuccess: (_, { projectId }) => {
      queryClient.invalidateQueries({ queryKey: ['projects', projectId, 'milestones'] });
      queryClient.invalidateQueries({ queryKey: ['projects', projectId] });
    },
  });
}
