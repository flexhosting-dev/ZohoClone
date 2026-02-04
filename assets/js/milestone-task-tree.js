function escHtml(str) {
    var d = document.createElement('div');
    d.textContent = str;
    return d.innerHTML;
}

function renderTaskRow(task, msId, projectId) {
    var statusClasses = {completed: 'bg-green-100 text-green-700', in_progress: 'bg-blue-100 text-blue-700', in_review: 'bg-yellow-100 text-yellow-700', todo: 'bg-gray-100 text-gray-700'};
    var priorityClasses = {high: 'bg-red-100 text-red-700', medium: 'bg-yellow-100 text-yellow-700', low: 'bg-blue-100 text-blue-700', none: 'bg-gray-100 text-gray-700'};
    var sc = statusClasses[task.status] || statusClasses.todo;
    var pc = priorityClasses[task.priority] || priorityClasses.none;
    var titleClass = task.status === 'completed' ? 'text-gray-500 line-through' : 'text-gray-900';
    var statusIcon = task.status === 'completed'
        ? '<svg class="h-4 w-4" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" /></svg>'
        : '<span class="w-2 h-2 rounded-full bg-current"></span>';

    var expandBtn = '';
    if (task.subtaskCount > 0) {
        expandBtn = '<button type="button" class="mr-1 p-0.5 text-gray-400 hover:text-gray-600" onclick="toggleSubtasks(this,\'' + task.id + '\',\'' + msId + '\',\'' + projectId + '\')">'
            + '<svg class="subtask-chevron h-3.5 w-3.5 transition-transform duration-150" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="m9 5 7 7-7 7" /></svg>'
            + '</button>';
    }

    var subtaskBadge = task.subtaskCount > 0
        ? ' <span class="ml-1.5 text-xs text-gray-400">(' + task.completedSubtaskCount + '/' + task.subtaskCount + ')</span>'
        : '';

    return '<li class="py-2 pl-2">'
        + '<div class="flex items-center justify-between">'
        + '<div class="flex items-center">'
        + expandBtn
        + '<span class="inline-flex items-center justify-center h-6 w-6 rounded-full text-xs ' + sc + '">' + statusIcon + '</span>'
        + '<span class="ml-3 text-sm ' + titleClass + '">' + escHtml(task.title) + subtaskBadge + '</span>'
        + '</div>'
        + '<span class="text-xs font-medium px-2 py-0.5 rounded-full ' + pc + '">' + escHtml(task.priorityLabel) + '</span>'
        + '</div>'
        + '</li>';
}

window.loadMoreTasks = function(btn) {
    var url = btn.dataset.url + '?offset=' + btn.dataset.offset + '&limit=10';
    var msId = btn.dataset.milestoneId;
    var list = document.getElementById('task-tree-' + msId);
    var projectId = list.dataset.projectId;
    btn.textContent = 'Loading...';
    fetch(url, {headers: {'X-Requested-With': 'XMLHttpRequest'}})
        .then(function(r) {
            if (!r.ok) throw new Error(r.status);
            return r.json();
        })
        .then(function(data) {
            data.tasks.forEach(function(task) {
                list.insertAdjacentHTML('beforeend', renderTaskRow(task, msId, projectId));
            });
            btn.dataset.offset = parseInt(btn.dataset.offset) + data.tasks.length;
            if (data.hasMore) {
                var remaining = data.total - parseInt(btn.dataset.offset);
                btn.textContent = '+ ' + remaining + ' more tasks';
            } else {
                btn.remove();
            }
        })
        .catch(function(e) { console.error('load more failed:', e); btn.textContent = 'Error loading tasks'; });
};

window.toggleSubtasks = function(btn, taskId, msId, projectId) {
    var container = document.getElementById('subtasks-' + taskId);
    var chevron = btn.querySelector('.subtask-chevron');
    if (container) {
        container.classList.toggle('hidden');
        chevron.classList.toggle('rotate-90');
        return;
    }
    chevron.classList.add('rotate-90');
    var url = '/projects/' + projectId + '/milestones/' + msId + '/tasks/' + taskId + '/subtasks';
    fetch(url, {headers: {'X-Requested-With': 'XMLHttpRequest'}})
        .then(function(r) {
            if (!r.ok) { chevron.classList.remove('rotate-90'); throw new Error(r.status); }
            return r.json();
        })
        .then(function(data) {
            var html = '<ul id="subtasks-' + taskId + '" class="ml-7 border-l border-gray-200 mt-1">';
            data.subtasks.forEach(function(st) {
                html += renderTaskRow(st, msId, projectId);
            });
            html += '</ul>';
            btn.closest('li').insertAdjacentHTML('beforeend', html);
        })
        .catch(function(e) { console.error('subtask load failed:', e); });
};
