import { Activity as ActivityIcon } from 'lucide-react';
import { Card, CardContent } from '@/components/ui/card';
import { Avatar, AvatarFallback } from '@/components/ui/avatar';
import type { Activity } from '@/types';
import { format } from 'date-fns';

interface ActivityFeedProps {
  activities: Activity[];
}

export function ActivityFeed({ activities }: ActivityFeedProps) {
  const getInitials = (fullName: string) => {
    const names = fullName.split(' ');
    return names.length > 1
      ? `${names[0].charAt(0)}${names[1].charAt(0)}`.toUpperCase()
      : fullName.slice(0, 2).toUpperCase();
  };

  if (activities.length === 0) {
    return (
      <Card>
        <CardContent className="flex flex-col items-center justify-center py-12">
          <ActivityIcon className="h-12 w-12 text-muted-foreground mb-4" />
          <h3 className="text-lg font-semibold mb-2">No activity yet</h3>
          <p className="text-muted-foreground text-center">
            Activity will appear here as you work on this project
          </p>
        </CardContent>
      </Card>
    );
  }

  return (
    <div className="space-y-4">
      {activities.map((activity) => (
        <div key={activity.id} className="flex gap-3">
          <Avatar className="h-8 w-8">
            <AvatarFallback className="text-xs">
              {getInitials(activity.user.fullName)}
            </AvatarFallback>
          </Avatar>
          <div className="flex-1 space-y-1">
            <p className="text-sm">
              <span className="font-medium">{activity.user.fullName}</span>
              {' '}
              {activity.action.replace('_', ' ')}
              {' '}
              {activity.entityName && (
                <span className="font-medium">{activity.entityName}</span>
              )}
            </p>
            <p className="text-xs text-muted-foreground">
              {format(new Date(activity.createdAt), 'MMM d, yyyy \'at\' h:mm a')}
            </p>
          </div>
        </div>
      ))}
    </div>
  );
}
