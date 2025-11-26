from django.contrib import admin
from .models import Todo

@admin.register(Todo)
class TodoAdmin(admin.ModelAdmin):
    list_display = ['title', 'due_date', 'status', 'created_at']
    list_filter = ['status', 'due_date']
    search_fields = ['title', 'description']
    list_editable = ['status']
