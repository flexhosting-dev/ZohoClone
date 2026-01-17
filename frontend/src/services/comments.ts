import api from './api';
import type { Comment, CreateCommentData, UpdateCommentData, PaginatedResponse } from '@/types';

export const commentsService = {
  async getComments(taskId: string): Promise<Comment[]> {
    const response = await api.get<PaginatedResponse<Comment>>(`/tasks/${taskId}/comments`);
    return response.data['hydra:member'] || response.data as unknown as Comment[];
  },

  async getComment(taskId: string, commentId: string): Promise<Comment> {
    const response = await api.get<Comment>(`/tasks/${taskId}/comments/${commentId}`);
    return response.data;
  },

  async createComment(taskId: string, data: CreateCommentData): Promise<Comment> {
    const response = await api.post<Comment>(`/tasks/${taskId}/comments`, data);
    return response.data;
  },

  async updateComment(taskId: string, commentId: string, data: UpdateCommentData): Promise<Comment> {
    const response = await api.patch<Comment>(`/tasks/${taskId}/comments/${commentId}`, data, {
      headers: { 'Content-Type': 'application/merge-patch+json' },
    });
    return response.data;
  },

  async deleteComment(taskId: string, commentId: string): Promise<void> {
    await api.delete(`/tasks/${taskId}/comments/${commentId}`);
  },
};
