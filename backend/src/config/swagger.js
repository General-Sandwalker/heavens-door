const swaggerJsdoc = require('swagger-jsdoc');

const options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'Heaven\'s Door API',
      version: '1.0.0',
      description: 'A JoJo-themed real estate application API - Stand Proud!',
      contact: {
        name: 'Heaven\'s Door Dev Team',
        email: 'admin@heavensdoor.com'
      },
      license: {
        name: 'MIT',
        url: 'https://opensource.org/licenses/MIT'
      }
    },
    servers: [
      {
        url: 'http://localhost:3000',
        description: 'Development server'
      },
      {
        url: 'https://api.heavensdoor.com',
        description: 'Production server'
      }
    ],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT',
          description: 'Enter your JWT token'
        }
      },
      schemas: {
        User: {
          type: 'object',
          properties: {
            id: {
              type: 'string',
              format: 'uuid',
              description: 'User ID'
            },
            first_name: {
              type: 'string',
              description: 'First name'
            },
            last_name: {
              type: 'string',
              description: 'Last name'
            },
            email: {
              type: 'string',
              format: 'email',
              description: 'Email address'
            },
            phone: {
              type: 'string',
              description: 'Phone number'
            },
            role: {
              type: 'string',
              enum: ['user', 'admin'],
              description: 'User role'
            },
            avatar_url: {
              type: 'string',
              format: 'uri',
              description: 'Profile picture URL'
            },
            created_at: {
              type: 'string',
              format: 'date-time',
              description: 'Account creation timestamp'
            }
          }
        },
        Property: {
          type: 'object',
          properties: {
            id: {
              type: 'string',
              format: 'uuid',
              description: 'Property ID'
            },
            title: {
              type: 'string',
              description: 'Property title'
            },
            description: {
              type: 'string',
              description: 'Property description'
            },
            price: {
              type: 'number',
              description: 'Property price'
            },
            type: {
              type: 'string',
              enum: ['apartment', 'house', 'villa', 'land', 'commercial'],
              description: 'Property type'
            },
            status: {
              type: 'string',
              enum: ['available', 'pending', 'sold', 'rented'],
              description: 'Property status'
            },
            address: {
              type: 'string',
              description: 'Property address'
            },
            city: {
              type: 'string',
              description: 'City'
            },
            state: {
              type: 'string',
              description: 'State/Province'
            },
            country: {
              type: 'string',
              description: 'Country'
            },
            latitude: {
              type: 'number',
              format: 'float',
              description: 'Latitude coordinate'
            },
            longitude: {
              type: 'number',
              format: 'float',
              description: 'Longitude coordinate'
            },
            bedrooms: {
              type: 'integer',
              description: 'Number of bedrooms'
            },
            bathrooms: {
              type: 'integer',
              description: 'Number of bathrooms'
            },
            area: {
              type: 'number',
              description: 'Area in square meters'
            },
            images: {
              type: 'array',
              items: {
                type: 'string',
                format: 'uri'
              },
              description: 'Property images'
            },
            amenities: {
              type: 'array',
              items: {
                type: 'string'
              },
              description: 'Property amenities'
            },
            created_at: {
              type: 'string',
              format: 'date-time',
              description: 'Creation timestamp'
            }
          }
        },
        Error: {
          type: 'object',
          properties: {
            success: {
              type: 'boolean',
              example: false
            },
            message: {
              type: 'string',
              description: 'Error message'
            },
            errors: {
              type: 'array',
              items: {
                type: 'object'
              },
              description: 'Validation errors'
            }
          }
        }
      }
    },
    tags: [
      {
        name: 'Authentication',
        description: 'User authentication endpoints'
      },
      {
        name: 'Users',
        description: 'User management endpoints'
      },
      {
        name: 'Properties',
        description: 'Property listing endpoints'
      },
      {
        name: 'Messages',
        description: 'Messaging endpoints'
      },
      {
        name: 'Favorites',
        description: 'Favorite properties endpoints'
      },
      {
        name: 'Admin',
        description: 'Admin dashboard and management endpoints'
      }
    ]
  },
  apis: ['./src/routes/*.js', './src/controllers/*.js']
};

const swaggerSpec = swaggerJsdoc(options);

module.exports = swaggerSpec;
