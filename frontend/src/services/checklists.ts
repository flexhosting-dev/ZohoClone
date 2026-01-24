import api from './api';
import type { ChecklistItem, ChecklistResponse, CreateChecklistItemData, UpdateChecklistItemData } from '@/types';

export const checklistsService = {
  async getChecklists(taskId: string): Promise<ChecklistResponse> {
    const response = await api.get<ChecklistResponse>(`/tasks/${taskId}/checklists`);
    return response.data;
  },

  async createChecklistItem(taskId: string, data: CreateChecklistItemData): Promise<ChecklistItem> {
    const response = await api.post<{ item: ChecklistItem }>(`/tasks/${taskId}/checklists`, data);
    return response.data.item;
  },

  async toggleChecklistItem(taskId: string, itemId: string): Promise<ChecklistItem> {
    const response = await api.post<{ item: ChecklistItem }>(`/tasks/${taskId}/checklists/${itemId}/toggle`);
    return response.data.item;
  },

  async updateChecklistItem(taskId: string, itemId: string, data: UpdateChecklistItemData): Promise<ChecklistItem> {
    const response = await api.patch<{ item: ChecklistItem }>(`/tasks/${taskId}/checklists/${itemId}`, data, {
      headers: { 'Content-Type': 'application/merge-patch+json' },
    });
    return response.data.item;
  },

  async deleteChecklistItem(taskId: string, itemId: string): Promise<void> {
    await api.delete(`/tasks/${taskId}/checklists/${itemId}`);
  },

  async reorderChecklistItems(taskId: string, itemIds: string[]): Promise<void> {
    await api.post(`/tasks/${taskId}/checklists/reorder`, { itemIds });
  },
};
