import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { commentsService } from '@/services/comments';
import type { CreateCommentData, UpdateCommentData } from '@/types';

export function useComments(taskId: string) {
  return useQuery({
    queryKey: ['tasks', taskId, 'comments'],
    queryFn: () => commentsService.getComments(taskId),
    enabled: !!taskId,
  });
}

export function useCreateComment() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ taskId, data }: { taskId: string; data: CreateCommentData }) =>
      commentsService.createComment(taskId, data),
    onSuccess: (_, { taskId }) => {
      queryClient.invalidateQueries({ queryKey: ['tasks', taskId, 'comments'] });
    },
  });
}

export function useUpdateComment() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ taskId, commentId, data }: { taskId: string; commentId: string; data: UpdateCommentData }) =>
      commentsService.updateComment(taskId, commentId, data),
    onSuccess: (_, { taskId }) => {
      queryClient.invalidateQueries({ queryKey: ['tasks', taskId, 'comments'] });
    },
  });
}

export function useDeleteComment() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ taskId, commentId }: { taskId: string; commentId: string }) =>
      commentsService.deleteComment(taskId, commentId),
    onSuccess: (_, { taskId }) => {
      queryClient.invalidateQueries({ queryKey: ['tasks', taskId, 'comments'] });
    },
  });
}
