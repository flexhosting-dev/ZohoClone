import api from './api';
import type { Milestone, CreateMilestoneData, UpdateMilestoneData, PaginatedResponse } from '@/types';

export const milestonesService = {
  async getMilestones(projectId: string): Promise<Milestone[]> {
    const response = await api.get<PaginatedResponse<Milestone>>(`/projects/${projectId}/milestones`);
    return response.data['hydra:member'] || response.data as unknown as Milestone[];
  },

  async getMilestone(projectId: string, milestoneId: string): Promise<Milestone> {
    const response = await api.get<Milestone>(`/projects/${projectId}/milestones/${milestoneId}`);
    return response.data;
  },

  async createMilestone(projectId: string, data: CreateMilestoneData): Promise<Milestone> {
    const response = await api.post<Milestone>(`/projects/${projectId}/milestones`, data);
    return response.data;
  },

  async updateMilestone(projectId: string, milestoneId: string, data: UpdateMilestoneData): Promise<Milestone> {
    const response = await api.patch<Milestone>(`/projects/${projectId}/milestones/${milestoneId}`, data, {
      headers: { 'Content-Type': 'application/merge-patch+json' },
    });
    return response.data;
  },

  async deleteMilestone(projectId: string, milestoneId: string): Promise<void> {
    await api.delete(`/projects/${projectId}/milestones/${milestoneId}`);
  },
};
