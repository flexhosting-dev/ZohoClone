import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { Loader2 } from 'lucide-react';
import { useCreateMilestone, useUpdateMilestone } from '@/hooks/useMilestones';
import { useToast } from '@/hooks/useToast';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import type { Milestone, MilestoneStatus } from '@/types';

const milestoneSchema = z.object({
  name: z.string().min(1, 'Milestone name is required'),
  description: z.string().optional(),
  status: z.enum(['open', 'completed']).default('open'),
  dueDate: z.string().optional(),
});

type MilestoneFormData = z.infer<typeof milestoneSchema>;

interface MilestoneFormProps {
  projectId: string;
  milestone?: Milestone;
  onSuccess: () => void;
}

export function MilestoneForm({ projectId, milestone, onSuccess }: MilestoneFormProps) {
  const createMilestone = useCreateMilestone();
  const updateMilestone = useUpdateMilestone();
  const { toast } = useToast();

  const {
    register,
    handleSubmit,
    setValue,
    watch,
    formState: { errors },
  } = useForm<MilestoneFormData>({
    resolver: zodResolver(milestoneSchema),
    defaultValues: {
      name: milestone?.name || '',
      description: milestone?.description || '',
      status: milestone?.status || 'open',
      dueDate: milestone?.dueDate || '',
    },
  });

  const isEditing = !!milestone;
  const isPending = createMilestone.isPending || updateMilestone.isPending;

  const onSubmit = async (data: MilestoneFormData) => {
    try {
      if (isEditing) {
        await updateMilestone.mutateAsync({
          projectId,
          milestoneId: milestone.id,
          data,
        });
        toast({
          title: 'Milestone updated',
          description: 'The milestone has been updated successfully.',
        });
      } else {
        await createMilestone.mutateAsync({ projectId, data });
        toast({
          title: 'Milestone created',
          description: 'Your new milestone has been created.',
        });
      }
      onSuccess();
    } catch {
      toast({
        variant: 'destructive',
        title: 'Error',
        description: `Failed to ${isEditing ? 'update' : 'create'} milestone.`,
      });
    }
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
      <div className="space-y-2">
        <Label htmlFor="name">Milestone Name</Label>
        <Input
          id="name"
          placeholder="Enter milestone name"
          {...register('name')}
        />
        {errors.name && (
          <p className="text-sm text-destructive">{errors.name.message}</p>
        )}
      </div>

      <div className="space-y-2">
        <Label htmlFor="description">Description</Label>
        <Textarea
          id="description"
          placeholder="Enter milestone description"
          {...register('description')}
        />
      </div>

      <div className="grid grid-cols-2 gap-4">
        <div className="space-y-2">
          <Label htmlFor="status">Status</Label>
          <Select
            value={watch('status')}
            onValueChange={(value: MilestoneStatus) => setValue('status', value)}
          >
            <SelectTrigger>
              <SelectValue placeholder="Select status" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="open">Open</SelectItem>
              <SelectItem value="completed">Completed</SelectItem>
            </SelectContent>
          </Select>
        </div>

        <div className="space-y-2">
          <Label htmlFor="dueDate">Due Date</Label>
          <Input
            id="dueDate"
            type="date"
            {...register('dueDate')}
          />
        </div>
      </div>

      <div className="flex justify-end space-x-2 pt-4">
        <Button type="submit" disabled={isPending}>
          {isPending && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
          {isEditing ? 'Update' : 'Create'} Milestone
        </Button>
      </div>
    </form>
  );
}
