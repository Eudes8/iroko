import { PrismaClient, UserRole } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Seeding database...');

  // Create test users
  const client = await prisma.user.upsert({
    where: { email: 'client@test.com' },
    update: {},
    create: {
      email: 'client@test.com',
      password: '$2b$10$abcdef...', // Should be bcrypted
      name: 'Test Client',
      phone: '+225701234567',
      role: UserRole.CLIENT,
      bio: 'Un client de test',
      isVerified: true,
    },
  });

  const provider = await prisma.user.upsert({
    where: { email: 'provider@test.com' },
    update: {},
    create: {
      email: 'provider@test.com',
      password: '$2b$10$abcdef...', // Should be bcrypted
      name: 'Test Provider',
      phone: '+225701234567',
      role: UserRole.PROVIDER,
      bio: 'Un tuteur de mathématiques',
      isVerified: true,
      specialties: ['mathematics', 'physics'],
      hourlyRate: 25000,
      location: 'Abidjan, Plateau',
      averageRating: 4.8,
      reviewCount: 5,
    },
  });

  console.log('✅ Seeding complete');
  console.log({ client, provider });
}

main()
  .then(async () => {
    await prisma.$disconnect();
  })
  .catch(async (e) => {
    console.error(e);
    await prisma.$disconnect();
    process.exit(1);
  });
