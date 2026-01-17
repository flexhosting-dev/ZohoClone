import api from './api';
import type { Task, CreateTaskData, UpdateTaskData, TaskAssignee, PaginatedResponse } from '@/types';

export const tasksService = {
  // Tasks by milestone
  async getTasks(milestoneId: string): Promise<Task[]> {
    const response = await api.get<PaginatedResponse<Task>>(`/milestones/${milestoneId}/tasks`);
    return response.data['hydra:member'] || response.data as unknown as Task[];
  },

  async getTask(milestoneId: string, taskId: string): Promise<Task> {
    const response = await api.get<Task>(`/milestones/${milestoneId}/tasks/${taskId}`);
    return response.data;
  },

  async createTask(milestoneId: string, data: CreateTaskData): Promise<Task> {
    const response = await api.post<Task>(`/milestones/${milestoneId}/tasks`, data);
    return response.data;
  },

  async updateTask(milestoneId: string, taskId: string, data: UpdateTaskData): Promise<Task> {
    const response = await api.patch<Task>(`/milestones/${milestoneId}/tasks/${taskId}`, data, {
      headers: { 'Content-Type': 'application/merge-patch+json' },
    });
    return response.data;
  },

  async deleteTask(milestoneId: string, taskId: string): Promise<void> {
    await api.delete(`/milestones/${milestoneId}/tasks/${taskId}`);
  },

  // Tasks by project
  async getProjectTasks(projectId: string): Promise<Task[]> {
    const response = await api.get<PaginatedResponse<Task>>(`/projects/${projectId}/tasks`);
    return response.data['hydra:member'] || response.data as unknown as Task[];
  },

  // My tasks (across all projects)
  async getMyTasks(): Promise<Task[]> {
    const response = await api.get<PaginatedResponse<Task>>('/my-tasks');
    return response.data['hydra:member'] || response.data as unknown as Task[];
  },

  // Task assignees
  async getTaskAssignees(taskId: string): Promise<TaskAssignee[]> {
    const response = await api.get<PaginatedResponse<TaskAssignee>>(`/tasks/${taskId}/assignees`);
    return response.data['hydra:member'] || response.data as unknown as TaskAssignee[];
  },

  async assignUser(taskId: string, userId: string): Promise<TaskAssignee> {
    const response = await api.post<TaskAssignee>(`/tasks/${taskId}/assignees`, {
      user: `/api/users/${userId}`,
    });
    return response.data;
  },

  async unassignUser(taskId: string, assigneeId: string): Promise<void> {
    await api.delete(`/tasks/${taskId}/assignees/${assigneeId}`);
  },
};
