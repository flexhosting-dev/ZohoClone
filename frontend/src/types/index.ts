// Enums
export type ProjectStatus = 'active' | 'on_hold' | 'completed' | 'archived';
export type ProjectRole = 'admin' | 'member' | 'viewer';
export type TaskStatus = 'todo' | 'in_progress' | 'in_review' | 'completed';
export type TaskPriority = 'low' | 'medium' | 'high' | 'urgent';
export type MilestoneStatus = 'open' | 'completed';
export type ActivityAction = 'created' | 'updated' | 'deleted' | 'assigned' | 'unassigned' | 'commented' | 'status_changed' | 'member_added' | 'member_removed' | 'member_role_changed';

// User
export interface User {
  id: string;
  email: string;
  firstName: string;
  lastName: string;
  fullName: string;
  isVerified: boolean;
  createdAt: string;
}

// Project
export interface Project {
  id: string;
  name: string;
  description?: string;
  status: ProjectStatus;
  startDate?: string;
  endDate?: string;
  owner: User;
  createdAt: string;
  updatedAt: string;
  members: ProjectMember[];
  memberCount: number;
  milestoneCount: number;
}

export interface ProjectMember {
  id: string;
  user: User;
  role: ProjectRole;
  joinedAt: string;
}

export interface CreateProjectData {
  name: string;
  description?: string;
  status?: ProjectStatus;
  startDate?: string;
  endDate?: string;
}

export interface UpdateProjectData {
  name?: string;
  description?: string;
  status?: ProjectStatus;
  startDate?: string;
  endDate?: string;
}

// Milestone
export interface Milestone {
  id: string;
  project: Project;
  name: string;
  description?: string;
  dueDate?: string;
  status: MilestoneStatus;
  createdAt: string;
  updatedAt: string;
  taskCount: number;
  completedTaskCount: number;
  progress: number;
}

export interface CreateMilestoneData {
  name: string;
  description?: string;
  dueDate?: string;
  status?: MilestoneStatus;
}

export interface UpdateMilestoneData {
  name?: string;
  description?: string;
  dueDate?: string;
  status?: MilestoneStatus;
}

// Task
export interface Task {
  id: string;
  milestone: Milestone;
  parent?: Task;
  title: string;
  description?: string;
  status: TaskStatus;
  priority: TaskPriority;
  dueDate?: string;
  position: number;
  createdAt: string;
  updatedAt: string;
  subtasks: Task[];
  assignees: TaskAssignee[];
  subtaskCount: number;
  commentCount: number;
  project: Project;
  isOverdue: boolean;
}

export interface TaskAssignee {
  id: string;
  user: User;
  assignedAt: string;
  assignedBy?: User;
}

export interface CreateTaskData {
  title: string;
  description?: string;
  status?: TaskStatus;
  priority?: TaskPriority;
  dueDate?: string;
  position?: number;
  parent?: string;
}

export interface UpdateTaskData {
  title?: string;
  description?: string;
  status?: TaskStatus;
  priority?: TaskPriority;
  dueDate?: string;
  position?: number;
}

// Comment
export interface Comment {
  id: string;
  task: Task;
  author: User;
  content: string;
  createdAt: string;
  updatedAt: string;
  isEdited: boolean;
}

export interface CreateCommentData {
  content: string;
}

export interface UpdateCommentData {
  content: string;
}

// Activity
export interface Activity {
  id: string;
  user: User;
  entityType: string;
  entityId: string;
  entityName?: string;
  action: ActivityAction;
  metadata?: Record<string, unknown>;
  createdAt: string;
  description: string;
}

// Dashboard
export interface DashboardStats {
  totalProjects: number;
  totalTasks: number;
  overdueTasks: number;
  tasksDueToday: number;
  completedTasks: number;
}

export interface TasksByStatus {
  todo: number;
  in_progress: number;
  in_review: number;
  completed: number;
}

export interface DashboardData {
  stats: DashboardStats;
  tasksByStatus: TasksByStatus;
  recentActivities: Activity[];
  upcomingTasks: Task[];
}

// Auth
export interface LoginCredentials {
  email: string;
  password: string;
}

export interface RegisterData {
  email: string;
  password: string;
  firstName: string;
  lastName: string;
}

export interface AuthResponse {
  token: string;
  refresh_token?: string;
}

// API Response types
export interface ApiError {
  error?: string;
  errors?: Record<string, string>;
  message?: string;
}

export interface PaginatedResponse<T> {
  'hydra:member': T[];
  'hydra:totalItems': number;
  'hydra:view'?: {
    '@id': string;
    'hydra:first'?: string;
    'hydra:last'?: string;
    'hydra:next'?: string;
    'hydra:previous'?: string;
  };
}
