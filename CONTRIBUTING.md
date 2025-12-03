# Contributing to Heaven's Door

Thank you for your interest in contributing to Heaven's Door! 🌟

## Table of Contents
- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)

---

## Code of Conduct

### Our Pledge
We are committed to providing a welcoming and inspiring community for all.

### Our Standards
- Be respectful and inclusive
- Accept constructive criticism gracefully
- Focus on what's best for the community
- Show empathy towards other community members

### Unacceptable Behavior
- Harassment, trolling, or insulting comments
- Public or private harassment
- Publishing others' private information
- Other conduct that could be considered inappropriate

---

## Getting Started

1. **Fork the repository**
   ```bash
   # Click "Fork" button on GitHub
   ```

2. **Clone your fork**
   ```bash
   git clone https://github.com/YOUR_USERNAME/heavens-door.git
   cd heavens-door
   ```

3. **Add upstream remote**
   ```bash
   git remote add upstream https://github.com/ORIGINAL_OWNER/heavens-door.git
   ```

4. **Set up development environment**
   ```bash
   ./start.sh
   ```

---

## How to Contribute

### Reporting Bugs
- Use the GitHub issue tracker
- Check if the issue already exists
- Include:
  - Clear description
  - Steps to reproduce
  - Expected vs actual behavior
  - System information
  - Screenshots (if applicable)

### Suggesting Features
- Open a GitHub issue with `[Feature Request]` prefix
- Describe the feature clearly
- Explain the use case
- Consider implementation details

### Improving Documentation
- Documentation contributions are highly valued!
- Fix typos, clarify confusing sections
- Add examples and diagrams
- Update outdated information

---

## Development Workflow

1. **Create a branch**
   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/bug-description
   ```

2. **Make your changes**
   - Write clean, readable code
   - Follow coding standards
   - Add tests for new features
   - Update documentation

3. **Test your changes**
   ```bash
   # Backend tests
   cd backend
   npm test
   
   # Frontend tests
   cd frontend
   flutter test
   ```

4. **Commit your changes**
   ```bash
   git add .
   git commit -m "feat: add new feature"
   ```

5. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Open a Pull Request**
   - Go to the original repository
   - Click "New Pull Request"
   - Select your fork and branch
   - Fill in the PR template

---

## Coding Standards

### Backend (Node.js/Express)

**Style Guide:**
- Use ES6+ features
- 2 spaces for indentation
- Semicolons required
- camelCase for variables and functions
- PascalCase for classes
- UPPERCASE for constants

**Best Practices:**
```javascript
// Good
const getUserById = async (userId) => {
  try {
    const result = await query('SELECT * FROM users WHERE id = $1', [userId]);
    return result.rows[0];
  } catch (error) {
    console.error('Error fetching user:', error);
    throw error;
  }
};

// Bad
const getUser = (id) => {
  return query('SELECT * FROM users WHERE id = ' + id); // SQL injection!
};
```

**File Structure:**
- Controllers: Handle HTTP requests
- Services: Business logic
- Models: Database queries
- Middleware: Request processing
- Routes: API endpoints

### Frontend (Flutter/Dart)

**Style Guide:**
- Follow official Dart style guide
- 2 spaces for indentation
- camelCase for variables
- PascalCase for classes
- Use `const` constructors when possible

**Best Practices:**
```dart
// Good
class PropertyCard extends StatelessWidget {
  final Property property;
  
  const PropertyCard({
    super.key,
    required this.property,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(property.title),
        subtitle: Text(property.priceFormatted),
      ),
    );
  }
}

// Bad
class PropertyCard extends StatelessWidget {
  Property? property; // Should be final
  
  PropertyCard({this.property}); // Missing key, const
  
  @override
  Widget build(context) { // Missing BuildContext type
    return Card(
      child: Text(property!.title), // Null assertion
    );
  }
}
```

**Widget Organization:**
- Break down large widgets
- Use composition over inheritance
- Separate business logic from UI
- Use providers for state management

### Database

**SQL Best Practices:**
- Use parameterized queries (prevent SQL injection)
- Index frequently queried columns
- Use foreign keys for referential integrity
- Write clear table and column names
- Add comments for complex queries

---

## Commit Guidelines

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification.

### Commit Message Format
```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting)
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `chore`: Maintenance tasks
- `ci`: CI/CD changes

### Examples
```bash
feat(auth): add JWT token refresh endpoint

fix(properties): resolve image loading issue on slow networks

docs(api): update authentication endpoint documentation

style(frontend): format code with dartfmt

refactor(backend): extract database queries to separate service

test(messages): add unit tests for message controller

chore(deps): update Flutter dependencies
```

---

## Pull Request Process

### Before Submitting

1. **Update from upstream**
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

2. **Run tests**
   ```bash
   # Backend
   npm test
   
   # Frontend
   flutter test
   ```

3. **Run linters**
   ```bash
   # Backend
   npm run lint
   
   # Frontend
   flutter analyze
   ```

4. **Update documentation**
   - Update README if needed
   - Update API docs for new endpoints
   - Add inline code comments

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Refactoring
- [ ] Performance improvement

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing performed

## Screenshots (if applicable)
Add screenshots for UI changes

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Code is commented where necessary
- [ ] Documentation updated
- [ ] No new warnings generated
- [ ] Tests pass locally

## Related Issues
Closes #123
```

### Review Process

1. **Automated Checks**
   - CI/CD pipeline runs
   - Tests must pass
   - Linters must pass

2. **Code Review**
   - At least one approval required
   - Address reviewer feedback
   - Make requested changes

3. **Merge**
   - Squash and merge preferred
   - Delete branch after merge

---

## Project Structure

### Backend
```
backend/
├── src/
│   ├── config/          # Configuration files
│   ├── controllers/     # Request handlers
│   ├── middleware/      # Custom middleware
│   ├── routes/          # API routes
│   └── server.js        # Entry point
├── migrations/          # Database migrations
├── tests/               # Test files
└── package.json
```

### Frontend
```
frontend/
├── lib/
│   ├── models/          # Data models
│   ├── providers/       # State management
│   ├── screens/         # UI screens
│   ├── services/        # API services
│   ├── widgets/         # Reusable widgets
│   ├── utils/           # Utilities
│   └── main.dart        # Entry point
├── test/                # Test files
└── pubspec.yaml
```

---

## Testing Guidelines

### Backend Tests
```javascript
describe('Auth Controller', () => {
  it('should register a new user', async () => {
    const response = await request(app)
      .post('/api/auth/register')
      .send({
        email: 'test@example.com',
        password: 'password123',
        firstName: 'Test',
        lastName: 'User'
      });
    
    expect(response.status).toBe(201);
    expect(response.body).toHaveProperty('token');
  });
});
```

### Frontend Tests
```dart
testWidgets('PropertyCard displays property information', (tester) async {
  final property = Property(/* ... */);
  
  await tester.pumpWidget(
    MaterialApp(
      home: PropertyCard(property: property),
    ),
  );
  
  expect(find.text(property.title), findsOneWidget);
  expect(find.text(property.priceFormatted), findsOneWidget);
});
```

---

## Documentation

### Code Comments
```dart
/// Fetches properties from the API with optional filters.
///
/// Returns a [List<Property>] on success.
/// Throws [DioError] if the request fails.
///
/// Example:
/// ```dart
/// final properties = await fetchProperties(filters: {'city': 'Tokyo'});
/// ```
Future<List<Property>> fetchProperties({Map<String, dynamic>? filters}) async {
  // Implementation
}
```

### API Documentation
Update `docs/api/API_DOCUMENTATION.md` for:
- New endpoints
- Changed request/response formats
- New query parameters
- Authentication requirements

---

## Need Help?

- 📖 Read the [documentation](docs/)
- 🐛 Check existing [issues](https://github.com/user/heavens-door/issues)
- 💬 Ask questions in discussions
- 📧 Contact maintainers

---

## Recognition

Contributors will be acknowledged in:
- README.md contributors section
- Release notes
- Project documentation

---

**"Thank you for helping make Heaven's Door even better!"**

*Stand Proud!* 🌟
