import { useState, useRef, useEffect } from 'react';
import {
  DndContext,
  DragEndEvent,
  closestCenter,
  PointerSensor,
  useSensor,
  useSensors,
} from '@dnd-kit/core';
import {
  SortableContext,
  useSortable,
  verticalListSortingStrategy,
} from '@dnd-kit/sortable';
import { CSS } from '@dnd-kit/utilities';
import { Plus, GripVertical, Trash2, Loader2 } from 'lucide-react';
import { Checkbox } from '@/components/ui/checkbox';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';
import { Progress } from '@/components/ui/progress';
import {
  useChecklists,
  useCreateChecklistItem,
  useToggleChecklistItem,
  useUpdateChecklistItem,
  useDeleteChecklistItem,
  useReorderChecklistItems,
} from '@/hooks/useChecklists';
import { cn } from '@/utils/cn';
import type { ChecklistItem } from '@/types';

interface ChecklistPanelProps {
  taskId: string;
}

interface SortableChecklistItemProps {
  item: ChecklistItem;
  taskId: string;
  onToggle: () => void;
  onUpdate: (title: string) => void;
  onDelete: () => void;
  isToggling: boolean;
  isDeleting: boolean;
}

function SortableChecklistItem({
  item,
  onToggle,
  onUpdate,
  onDelete,
  isToggling,
  isDeleting,
}: SortableChecklistItemProps) {
  const [isEditing, setIsEditing] = useState(false);
  const [editValue, setEditValue] = useState(item.title);
  const inputRef = useRef<HTMLInputElement>(null);

  const {
    attributes,
    listeners,
    setNodeRef,
    transform,
    transition,
    isDragging,
  } = useSortable({ id: item.id });

  const style = {
    transform: CSS.Transform.toString(transform),
    transition,
  };

  useEffect(() => {
    if (isEditing && inputRef.current) {
      inputRef.current.focus();
      inputRef.current.select();
    }
  }, [isEditing]);

  const handleSave = () => {
    const trimmed = editValue.trim();
    if (trimmed && trimmed !== item.title) {
      onUpdate(trimmed);
    } else {
      setEditValue(item.title);
    }
    setIsEditing(false);
  };

  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter') {
      handleSave();
    } else if (e.key === 'Escape') {
      setEditValue(item.title);
      setIsEditing(false);
    }
  };

  return (
    <div
      ref={setNodeRef}
      style={style}
      className={cn(
        'group flex items-center gap-2 p-2 rounded-md hover:bg-muted/50 transition-colors',
        isDragging && 'opacity-50 bg-muted',
        isDeleting && 'opacity-50'
      )}
    >
      <div
        {...attributes}
        {...listeners}
        className="cursor-grab text-muted-foreground opacity-0 group-hover:opacity-100 transition-opacity"
      >
        <GripVertical className="h-4 w-4" />
      </div>

      <div className="relative">
        {isToggling ? (
          <Loader2 className="h-4 w-4 animate-spin" />
        ) : (
          <Checkbox
            checked={item.isCompleted}
            onCheckedChange={onToggle}
            className="data-[state=checked]:bg-green-600 data-[state=checked]:border-green-600"
          />
        )}
      </div>

      {isEditing ? (
        <Input
          ref={inputRef}
          value={editValue}
          onChange={(e) => setEditValue(e.target.value)}
          onBlur={handleSave}
          onKeyDown={handleKeyDown}
          className="flex-1 h-7 text-sm"
        />
      ) : (
        <span
          onClick={() => setIsEditing(true)}
          className={cn(
            'flex-1 text-sm cursor-pointer',
            item.isCompleted && 'line-through text-muted-foreground'
          )}
        >
          {item.title}
        </span>
      )}

      <Button
        variant="ghost"
        size="icon"
        className="h-6 w-6 opacity-0 group-hover:opacity-100 transition-opacity text-muted-foreground hover:text-destructive"
        onClick={onDelete}
        disabled={isDeleting}
      >
        <Trash2 className="h-3 w-3" />
      </Button>
    </div>
  );
}

export function ChecklistPanel({ taskId }: ChecklistPanelProps) {
  const [newItemTitle, setNewItemTitle] = useState('');
  const [togglingItems, setTogglingItems] = useState<Set<string>>(new Set());
  const [deletingItems, setDeletingItems] = useState<Set<string>>(new Set());
  const inputRef = useRef<HTMLInputElement>(null);

  const { data, isLoading, error } = useChecklists(taskId);
  const createItem = useCreateChecklistItem();
  const toggleItem = useToggleChecklistItem();
  const updateItem = useUpdateChecklistItem();
  const deleteItem = useDeleteChecklistItem();
  const reorderItems = useReorderChecklistItems();

  const sensors = useSensors(
    useSensor(PointerSensor, {
      activationConstraint: {
        distance: 8,
      },
    })
  );

  const handleCreate = async () => {
    const title = newItemTitle.trim();
    if (!title) return;

    try {
      await createItem.mutateAsync({ taskId, data: { title } });
      setNewItemTitle('');
      inputRef.current?.focus();
    } catch {
      // Error handled by mutation
    }
  };

  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter') {
      handleCreate();
    }
  };

  const handleToggle = async (itemId: string) => {
    setTogglingItems((prev) => new Set(prev).add(itemId));
    try {
      await toggleItem.mutateAsync({ taskId, itemId });
    } finally {
      setTogglingItems((prev) => {
        const next = new Set(prev);
        next.delete(itemId);
        return next;
      });
    }
  };

  const handleUpdate = async (itemId: string, title: string) => {
    try {
      await updateItem.mutateAsync({ taskId, itemId, data: { title } });
    } catch {
      // Error handled by mutation
    }
  };

  const handleDelete = async (itemId: string) => {
    setDeletingItems((prev) => new Set(prev).add(itemId));
    try {
      await deleteItem.mutateAsync({ taskId, itemId });
    } finally {
      setDeletingItems((prev) => {
        const next = new Set(prev);
        next.delete(itemId);
        return next;
      });
    }
  };

  const handleDragEnd = async (event: DragEndEvent) => {
    const { active, over } = event;

    if (!over || active.id === over.id || !data?.items) return;

    const oldIndex = data.items.findIndex((item) => item.id === active.id);
    const newIndex = data.items.findIndex((item) => item.id === over.id);

    if (oldIndex === -1 || newIndex === -1) return;

    const newOrder = [...data.items];
    const [movedItem] = newOrder.splice(oldIndex, 1);
    newOrder.splice(newIndex, 0, movedItem);

    const itemIds = newOrder.map((item) => item.id);

    try {
      await reorderItems.mutateAsync({ taskId, itemIds });
    } catch {
      // Error handled by mutation
    }
  };

  if (isLoading) {
    return (
      <div className="flex items-center justify-center p-8">
        <Loader2 className="h-6 w-6 animate-spin text-muted-foreground" />
      </div>
    );
  }

  if (error) {
    return (
      <div className="text-sm text-destructive p-4">
        Failed to load checklist items
      </div>
    );
  }

  const items = data?.items ?? [];
  const totalCount = data?.totalCount ?? 0;
  const completedCount = data?.completedCount ?? 0;
  const progress = totalCount > 0 ? (completedCount / totalCount) * 100 : 0;

  return (
    <div className="space-y-4">
      {/* Progress indicator */}
      {totalCount > 0 && (
        <div className="space-y-1">
          <div className="flex items-center justify-between text-sm">
            <span className="text-muted-foreground">Progress</span>
            <span className="font-medium">
              {completedCount}/{totalCount}
            </span>
          </div>
          <Progress value={progress} className="h-2" />
        </div>
      )}

      {/* Add new item */}
      <div className="flex items-center gap-2">
        <Input
          ref={inputRef}
          value={newItemTitle}
          onChange={(e) => setNewItemTitle(e.target.value)}
          onKeyDown={handleKeyDown}
          placeholder="Add an item..."
          className="flex-1"
          disabled={createItem.isPending}
        />
        <Button
          size="icon"
          onClick={handleCreate}
          disabled={!newItemTitle.trim() || createItem.isPending}
        >
          {createItem.isPending ? (
            <Loader2 className="h-4 w-4 animate-spin" />
          ) : (
            <Plus className="h-4 w-4" />
          )}
        </Button>
      </div>

      {/* Checklist items */}
      {items.length > 0 ? (
        <DndContext
          sensors={sensors}
          collisionDetection={closestCenter}
          onDragEnd={handleDragEnd}
        >
          <SortableContext
            items={items.map((item) => item.id)}
            strategy={verticalListSortingStrategy}
          >
            <div className="space-y-1">
              {items.map((item) => (
                <SortableChecklistItem
                  key={item.id}
                  item={item}
                  taskId={taskId}
                  onToggle={() => handleToggle(item.id)}
                  onUpdate={(title) => handleUpdate(item.id, title)}
                  onDelete={() => handleDelete(item.id)}
                  isToggling={togglingItems.has(item.id)}
                  isDeleting={deletingItems.has(item.id)}
                />
              ))}
            </div>
          </SortableContext>
        </DndContext>
      ) : (
        <p className="text-sm text-muted-foreground italic py-4">
          No checklist items yet
        </p>
      )}
    </div>
  );
}
