import api from './api';
import type { Project, CreateProjectData, UpdateProjectData, ProjectMember, ProjectRole, PaginatedResponse } from '@/types';

export const projectsService = {
  async getProjects(): Promise<Project[]> {
    const response = await api.get<PaginatedResponse<Project>>('/projects');
    return response.data['hydra:member'] || response.data as unknown as Project[];
  },

  async getProject(id: string): Promise<Project> {
    const response = await api.get<Project>(`/projects/${id}`);
    return response.data;
  },

  async createProject(data: CreateProjectData): Promise<Project> {
    const response = await api.post<Project>('/projects', data);
    return response.data;
  },

  async updateProject(id: string, data: UpdateProjectData): Promise<Project> {
    const response = await api.patch<Project>(`/projects/${id}`, data, {
      headers: { 'Content-Type': 'application/merge-patch+json' },
    });
    return response.data;
  },

  async deleteProject(id: string): Promise<void> {
    await api.delete(`/projects/${id}`);
  },

  // Project Members
  async getProjectMembers(projectId: string): Promise<ProjectMember[]> {
    const response = await api.get<PaginatedResponse<ProjectMember>>(`/projects/${projectId}/members`);
    return response.data['hydra:member'] || response.data as unknown as ProjectMember[];
  },

  async addProjectMember(projectId: string, userId: string, role: ProjectRole = 'member'): Promise<ProjectMember> {
    const response = await api.post<ProjectMember>(`/projects/${projectId}/members`, {
      user: `/api/users/${userId}`,
      role,
    });
    return response.data;
  },

  async updateProjectMemberRole(projectId: string, memberId: string, role: ProjectRole): Promise<ProjectMember> {
    const response = await api.patch<ProjectMember>(`/projects/${projectId}/members/${memberId}`, { role }, {
      headers: { 'Content-Type': 'application/merge-patch+json' },
    });
    return response.data;
  },

  async removeProjectMember(projectId: string, memberId: string): Promise<void> {
    await api.delete(`/projects/${projectId}/members/${memberId}`);
  },
};
