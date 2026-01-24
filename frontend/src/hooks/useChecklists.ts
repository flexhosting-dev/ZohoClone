import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { checklistsService } from '@/services/checklists';
import type { CreateChecklistItemData, UpdateChecklistItemData } from '@/types';

export function useChecklists(taskId: string) {
  return useQuery({
    queryKey: ['tasks', taskId, 'checklists'],
    queryFn: () => checklistsService.getChecklists(taskId),
    enabled: !!taskId,
  });
}

export function useCreateChecklistItem() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ taskId, data }: { taskId: string; data: CreateChecklistItemData }) =>
      checklistsService.createChecklistItem(taskId, data),
    onSuccess: (_, { taskId }) => {
      queryClient.invalidateQueries({ queryKey: ['tasks', taskId, 'checklists'] });
    },
  });
}

export function useToggleChecklistItem() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ taskId, itemId }: { taskId: string; itemId: string }) =>
      checklistsService.toggleChecklistItem(taskId, itemId),
    onSuccess: (_, { taskId }) => {
      queryClient.invalidateQueries({ queryKey: ['tasks', taskId, 'checklists'] });
    },
  });
}

export function useUpdateChecklistItem() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ taskId, itemId, data }: { taskId: string; itemId: string; data: UpdateChecklistItemData }) =>
      checklistsService.updateChecklistItem(taskId, itemId, data),
    onSuccess: (_, { taskId }) => {
      queryClient.invalidateQueries({ queryKey: ['tasks', taskId, 'checklists'] });
    },
  });
}

export function useDeleteChecklistItem() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ taskId, itemId }: { taskId: string; itemId: string }) =>
      checklistsService.deleteChecklistItem(taskId, itemId),
    onSuccess: (_, { taskId }) => {
      queryClient.invalidateQueries({ queryKey: ['tasks', taskId, 'checklists'] });
    },
  });
}

export function useReorderChecklistItems() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ taskId, itemIds }: { taskId: string; itemIds: string[] }) =>
      checklistsService.reorderChecklistItems(taskId, itemIds),
    onSuccess: (_, { taskId }) => {
      queryClient.invalidateQueries({ queryKey: ['tasks', taskId, 'checklists'] });
    },
  });
}
