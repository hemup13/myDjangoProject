# ai-dev-tools

##################################### Module 1 --- Homework #############################################
## Installing Python
winget install 9NQ7512CXL7T

## Installing Django
# Create a project folder
mkdir my-django-project
cd my-django-project

# Create virtual environment
python -m venv .venv

# Activate virtual environment
.venv\Scripts\Activate.ps1

# Install Django
pip install Django

# Verify Django installation
py -m django --version

##Output: 5.2.8


####################Creating Project and an App in Django ##################

# Navigate to where you want your project (e.g., Documents)
cd "c:\Users\heman\Documents"

mkdir myDjangoProject 

cd myDjangoProject

# Create virtual environment
py -m venv venv

# Activate it
venv\Scripts\activate

# Install Django
pip install django

# Outcome: Successfully installed asgiref-3.11.0 django-5.2.8 sqlparse-0.5.3 tzdata-2025.2

dir mysite
# Output
# Directory of c:\Users\heman\Documents\myDjangoProject\mysite

# 26/11/2025  14:14    <DIR>          .
# 26/11/2025  14:14    <DIR>          ..
# 26/11/2025  14:14               405 asgi.py
# 26/11/2025  14:14             3,283 settings.py
# 26/11/2025  14:14               784 urls.py
# 26/11/2025  14:14               405 wsgi.py
# 26/11/2025  14:14                 0 __init__.py

Open URL: http://127.0.0.1:8000/
Outcome: <img width="1522" height="822" alt="image" src="https://github.com/user-attachments/assets/d8ddf565-1466-4856-8e33-e8e8f4b6730c" />

########### Create Your First App ###################

py manage.py startapp TODO

# Added "TODO" in INSTALLED_APPS inside "mysite/settings.py"

py manage.py makemigrations

## Open todos/models.py and replace everything with:
from django.db import models
from django.utils import timezone

class Todo(models.Model):
    STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('resolved', 'Resolved'),
    ]
    
    title = models.CharField(max_length=200)
    description = models.TextField(blank=True)
    due_date = models.DateField(null=True, blank=True)
    status = models.CharField(max_length=10, choices=STATUS_CHOICES, default='pending')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-created_at']
    
    def __str__(self):
        return self.title
    
    def is_overdue(self):
        if self.due_date and self.status == 'pending':
            return self.due_date < timezone.now().date()
        return False


## Create and Apply Migrations
# Create migration files
py manage.py makemigrations

# Apply migrations to database
py manage.py migrate

## Open todos/admin.py and replace with:
from django.contrib import admin
from .models import Todo

@admin.register(Todo)
class TodoAdmin(admin.ModelAdmin):
    list_display = ['title', 'due_date', 'status', 'created_at']
    list_filter = ['status', 'due_date']
    search_fields = ['title', 'description']
    list_editable = ['status']


## Open todos/views.py and replace with:
from django.shortcuts import render, redirect, get_object_or_404
from django.urls import reverse
from .models import Todo

def todo_list(request):
    todos = Todo.objects.all()
    return render(request, 'todos/todo_list.html', {'todos': todos})

def todo_create(request):
    if request.method == 'POST':
        title = request.POST.get('title')
        description = request.POST.get('description')
        due_date = request.POST.get('due_date') or None
        
        Todo.objects.create(
            title=title,
            description=description,
            due_date=due_date
        )
        return redirect('todo_list')
    
    return render(request, 'todos/todo_form.html', {'action': 'Create'})

def todo_edit(request, pk):
    todo = get_object_or_404(Todo, pk=pk)
    
    if request.method == 'POST':
        todo.title = request.POST.get('title')
        todo.description = request.POST.get('description')
        todo.due_date = request.POST.get('due_date') or None
        todo.save()
        return redirect('todo_list')
    
    return render(request, 'todos/todo_form.html', {'todo': todo, 'action': 'Edit'})

def todo_delete(request, pk):
    todo = get_object_or_404(Todo, pk=pk)
    
    if request.method == 'POST':
        todo.delete()
        return redirect('todo_list')
    
    return render(request, 'todos/todo_confirm_delete.html', {'todo': todo})

def todo_toggle_status(request, pk):
    todo = get_object_or_404(Todo, pk=pk)
    
    if todo.status == 'pending':
        todo.status = 'resolved'
    else:
        todo.status = 'pending'
    
    todo.save()
    return redirect('todo_list')


## Create a new file todos/urls.py:
from django.urls import path
from . import views

urlpatterns = [
    path('', views.todo_list, name='todo_list'),
    path('create/', views.todo_create, name='todo_create'),
    path('edit/<int:pk>/', views.todo_edit, name='todo_edit'),
    path('delete/<int:pk>/', views.todo_delete, name='todo_delete'),
    path('toggle/<int:pk>/', views.todo_toggle_status, name='todo_toggle_status'),
]

## Open mysite/urls.py and update it:
from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('todos.urls')),
]


### Create templates folder structure
mkdir todos\templates
mkdir todos\templates\todos

## Create todos/templates/todos/base.html:
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{% block title %}TODO App{% endblock %}</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            padding: 30px;
        }
        
        h1 {
            color: #333;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .btn {
            display: inline-block;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
            transition: all 0.3s;
        }
        
        .btn-primary {
            background: #667eea;
            color: white;
        }
        
        .btn-primary:hover {
            background: #5568d3;
        }
        
        .btn-success {
            background: #28a745;
            color: white;
        }
        
        .btn-danger {
            background: #dc3545;
            color: white;
        }
        
        .btn-warning {
            background: #ffc107;
            color: #333;
        }
        
        .btn-sm {
            padding: 5px 10px;
            font-size: 12px;
        }
    </style>
</head>
<body>
    <div class="container">
        {% block content %}{% endblock %}
    </div>
</body>
</html>


## Create todos/templates/todos/todo_list.html:
{% extends 'todos/base.html' %}

{% block title %}My TODOs{% endblock %}

{% block content %}
<h1>My TODO List</h1>

<div style="margin-bottom: 20px;">
    <a href="{% url 'todo_create' %}" class="btn btn-primary">+ Add New TODO</a>
</div>

<style>
    .todo-item {
        background: #f8f9fa;
        padding: 15px;
        margin-bottom: 15px;
        border-radius: 8px;
        border-left: 4px solid #667eea;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    
    .todo-item.resolved {
        opacity: 0.6;
        border-left-color: #28a745;
    }
    
    .todo-item.overdue {
        border-left-color: #dc3545;
        background: #fff5f5;
    }
    
    .todo-content h3 {
        margin-bottom: 5px;
        color: #333;
    }
    
    .todo-content p {
        color: #666;
        margin-bottom: 8px;
    }
    
    .todo-meta {
        font-size: 12px;
        color: #999;
    }
    
    .todo-actions {
        display: flex;
        gap: 5px;
    }
    
    .badge {
        display: inline-block;
        padding: 3px 8px;
        border-radius: 3px;
        font-size: 11px;
        font-weight: bold;
        margin-right: 5px;
    }
    
    .badge-success {
        background: #28a745;
        color: white;
    }
    
    .badge-warning {
        background: #ffc107;
        color: #333;
    }
    
    .badge-danger {
        background: #dc3545;
        color: white;
    }
    
    .no-todos {
        text-align: center;
        padding: 40px;
        color: #999;
    }
</style>

{% if todos %}
    {% for todo in todos %}
    <div class="todo-item {% if todo.status == 'resolved' %}resolved{% elif todo.is_overdue %}overdue{% endif %}">
        <div class="todo-content">
            <h3>{{ todo.title }}</h3>
            {% if todo.description %}
                <p>{{ todo.description }}</p>
            {% endif %}
            <div class="todo-meta">
                {% if todo.status == 'resolved' %}
                    <span class="badge badge-success">✓ Resolved</span>
                {% else %}
                    <span class="badge badge-warning">Pending</span>
                {% endif %}
                
                {% if todo.due_date %}
                    {% if todo.is_overdue %}
                        <span class="badge badge-danger">⚠ Overdue: {{ todo.due_date }}</span>
                    {% else %}
                        Due: {{ todo.due_date }}
                    {% endif %}
                {% endif %}
            </div>
        </div>
        
        <div class="todo-actions">
            <form method="post" action="{% url 'todo_toggle_status' todo.pk %}" style="display: inline;">
                {% csrf_token %}
                {% if todo.status == 'pending' %}
                    <button type="submit" class="btn btn-success btn-sm">✓ Mark Done</button>
                {% else %}
                    <button type="submit" class="btn btn-warning btn-sm">↺ Reopen</button>
                {% endif %}
            </form>
            
            <a href="{% url 'todo_edit' todo.pk %}" class="btn btn-primary btn-sm">Edit</a>
            <a href="{% url 'todo_delete' todo.pk %}" class="btn btn-danger btn-sm">Delete</a>
        </div>
    </div>
    {% endfor %}
{% else %}
    <div class="no-todos">
        <h2>No TODOs yet!</h2>
        <p>Click "Add New TODO" to get started.</p>
    </div>
{% endif %}

{% endblock %}

## Create todos/templates/todos/todo_form.html:
{% extends 'todos/base.html' %}

{% block title %}{{ action }} TODO{% endblock %}

{% block content %}
<h1>{{ action }} TODO</h1>

<style>
    .form-group {
        margin-bottom: 20px;
    }
    
    label {
        display: block;
        margin-bottom: 5px;
        font-weight: bold;
        color: #333;
    }
    
    input[type="text"],
    input[type="date"],
    textarea {
        width: 100%;
        padding: 10px;
        border: 1px solid #ddd;
        border-radius: 5px;
        font-size: 14px;
    }
    
    textarea {
        resize: vertical;
        min-height: 100px;
    }
    
    .form-actions {
        display: flex;
        gap: 10px;
        margin-top: 20px;
    }
</style>

<form method="post">
    {% csrf_token %}
    
    <div class="form-group">
        <label for="title">Title *</label>
        <input type="text" id="title" name="title" value="{{ todo.title }}" required>
    </div>
    
    <div class="form-group">
        <label for="description">Description</label>
        <textarea id="description" name="description">{{ todo.description }}</textarea>
    </div>
    
    <div class="form-group">
        <label for="due_date">Due Date</label>
        <input type="date" id="due_date" name="due_date" value="{{ todo.due_date|date:'Y-m-d' }}">
    </div>
    
    <div class="form-actions">
        <button type="submit" class="btn btn-primary">{{ action }} TODO</button>
        <a href="{% url 'todo_list' %}" class="btn btn-danger">Cancel</a>
    </div>
</form>

{% endblock %}

### Create todos/templates/todos/todo_confirm_delete.html:
{% extends 'todos/base.html' %}

{% block title %}Delete TODO{% endblock %}

{% block content %}
<h1>Delete TODO</h1>

<style>
    .warning-box {
        background: #fff3cd;
        border: 1px solid #ffc107;
        border-radius: 5px;
        padding: 20px;
        margin: 20px 0;
    }
    
    .form-actions {
        display: flex;
        gap: 10px;
        margin-top: 20px;
    }
</style>

<div class="warning-box">
    <h3>Are you sure you want to delete this TODO?</h3>
    <p><strong>{{ todo.title }}</strong></p>
    {% if todo.description %}
        <p>{{ todo.description }}</p>
    {% endif %}
    <p style="color: #dc3545; margin-top: 10px;">This action cannot be undone!</p>
</div>

<form method="post">
    {% csrf_token %}
    <div class="form-actions">
        <button type="submit" class="btn btn-danger">Yes, Delete</button>
        <a href="{% url 'todo_list' %}" class="btn btn-primary">Cancel</a>
    </div>
</form>

{% endblock %}

##  Create Superuser
py manage.py createsuperuser

## Run the Server
py manage.py runserver


## First view for TODO App

<img width="945" height="491" alt="image" src="https://github.com/user-attachments/assets/5715dbe3-8780-4baf-964a-34eb868eca36" />

<img width="1692" height="610" alt="image" src="https://github.com/user-attachments/assets/ca54d719-97af-49e3-a0bc-8c4c4878b97f" />

<img width="1710" height="501" alt="image" src="https://github.com/user-attachments/assets/aeceffd3-f81f-45f9-b054-43a241bf16de" />






