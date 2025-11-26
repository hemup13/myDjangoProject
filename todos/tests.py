from django.test import TestCase, Client
from django.urls import reverse
from django.utils import timezone
from .models import Todo


class TodoModelTests(TestCase):
    def test_todo_str_returns_title(self):
        todo = Todo.objects.create(title='Test Title')
        self.assertEqual(str(todo), 'Test Title')

    def test_is_overdue_true_and_false(self):
        today = timezone.now().date()
        past_date = today.replace(year=today.year - 1)
        future_date = today.replace(year=today.year + 1)

        todo_pending_past = Todo.objects.create(title='Past Todo', due_date=past_date, status='pending')
        todo_pending_future = Todo.objects.create(title='Future Todo', due_date=future_date, status='pending')
        todo_resolved_past = Todo.objects.create(title='Resolved Past', due_date=past_date, status='resolved')

        self.assertTrue(todo_pending_past.is_overdue())
        self.assertFalse(todo_pending_future.is_overdue())
        self.assertFalse(todo_resolved_past.is_overdue())


class TodoViewTests(TestCase):
    def setUp(self):
        self.client = Client()

    def test_todo_list_view(self):
        Todo.objects.create(title='One')
        Todo.objects.create(title='Two')

        resp = self.client.get(reverse('todo_list'))
        self.assertEqual(resp.status_code, 200)
        self.assertContains(resp, 'One')
        self.assertContains(resp, 'Two')

    def test_todo_create_view(self):
        data = {'title': 'Created via test', 'description': '', 'due_date': ''}
        resp = self.client.post(reverse('todo_create'), data=data)
        # After creating, we should redirect to list
        self.assertEqual(resp.status_code, 302)
        self.assertTrue(Todo.objects.filter(title='Created via test').exists())

    def test_toggle_status_view(self):
        todo = Todo.objects.create(title='To Toggle')
        self.assertEqual(todo.status, 'pending')
        resp = self.client.post(reverse('todo_toggle_status', args=(todo.pk,)))
        self.assertEqual(resp.status_code, 302)
        todo.refresh_from_db()
        self.assertEqual(todo.status, 'resolved')

